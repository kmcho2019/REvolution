module TopModule(output reg zero);
    initial begin
        zero = 1'b0;
    end
    // No further assignments: zero stays 0 throughout
endmodule