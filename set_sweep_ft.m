function test_time = set_sweep_ft(vna)
    test_time = 5;
    writeline(vna,"SENS:FREQ:STAR 0.5E9;:SENS:FREQ:STOP 4.5E9");
    writeline(vna,"SENS:SWE:POIN 4001");
    cmd = sprintf("SENS:SWE:TIME %g", test_time);
    writeline(vna, cmd);
    writeline(vna,"INIT:CONT OFF");
end
