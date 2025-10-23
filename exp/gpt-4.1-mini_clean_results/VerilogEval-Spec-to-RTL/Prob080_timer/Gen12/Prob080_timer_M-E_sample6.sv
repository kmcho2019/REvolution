module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    reg [9:0] shift_reg;
    
    // Determine if shift_reg is zero (terminal count)
    assign tc = (shift_reg == 10'd0);

    always @(posedge clk) begin
        if (load) begin
            // Load parallel data into shift register
            shift_reg <= data;
        end else if (!tc) begin
            // Shift right by one bit if not terminal count
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
        // Else hold shift_reg at zero
    end
endmodule