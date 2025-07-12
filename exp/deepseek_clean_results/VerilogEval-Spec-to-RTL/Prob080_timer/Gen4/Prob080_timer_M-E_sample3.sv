module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    
    always @(posedge clk) begin
        if (load) begin
            // Initialize with '1' at MSB position
            shift_reg <= {1'b1, 9'b0};
        end else if (shift_reg != 0) begin
            // Shift right by 1 position
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end
    
    // Terminal count is when the '1' reaches LSB
    assign tc = shift_reg[0];

endmodule