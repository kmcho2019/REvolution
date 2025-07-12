module TopModule(output reg zero);
    initial begin
        zero = 1'b0;
    end
    // No always block or input signals change the output, so zero remains 0.
endmodule