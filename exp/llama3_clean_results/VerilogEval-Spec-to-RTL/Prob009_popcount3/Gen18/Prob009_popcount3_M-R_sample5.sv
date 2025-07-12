module TopModule(
    input [2:0] in,
    output [1:0] out
);

    reg [1:0] out_reg;

    always @(*) begin
        // Initialize a counter to 0
        out_reg = 0;
        
        // Count the number of '1's in the input vector
        if (in[0] == 1'b1) out_reg = out_reg + 1;
        if (in[1] == 1'b1) out_reg = out_reg + 1;
        if (in[2] == 1'b1) out_reg = out_reg + 1;
    end

    // Assign the result to the output
    assign out = out_reg;

endmodule