module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    reg [1:0] shift_reg;  // Small buffer for pipelined processing

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            shift_reg <= 2'b00;
            z <= 1'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[0], x};
            
            // Update seen_one flag
            if (!seen_one && x) begin
                seen_one <= 1'b1;
            end
            
            // Output logic - uses pipelined version of input
            if (!seen_one) begin
                z <= shift_reg[1];  // Pass through
            end else begin
                z <= ~shift_reg[1]; // Invert
            end
        end
    end

endmodule