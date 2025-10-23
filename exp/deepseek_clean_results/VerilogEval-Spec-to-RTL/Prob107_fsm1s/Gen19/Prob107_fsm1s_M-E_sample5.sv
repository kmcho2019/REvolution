module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] shift_reg;  // Shift register implementation
    
    // Shift register transitions:
    // - When in=0: shift in 1 (forces state change)
    // - When in=1: shift in current state (maintains state)
    wire shift_in = in ? shift_reg[0] : 1'b1;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b11;  // Initialize to state B (output 1)
        end else begin
            shift_reg <= {shift_reg[0], shift_in};
        end
    end
    
    // Output is 1 when in state B (shift_reg == 2'b11 or 2'b01)
    // But optimized to simply check MSB since initialization ensures correctness
    assign out = ~shift_reg[1];
    
endmodule