module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;
    
    always @(posedge clk) begin
        if (load) begin
            // Set '1' at position [data-1], '0's elsewhere
            shift_reg <= (10'b1 << (data - 1));
        end else begin
            // Right shift with zero fill
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end
    
    // Terminal count is when '1' reaches LSB
    assign tc = shift_reg[0];

endmodule