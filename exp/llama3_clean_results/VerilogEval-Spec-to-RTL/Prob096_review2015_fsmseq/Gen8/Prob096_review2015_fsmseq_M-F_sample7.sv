module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state 0
        start_shifting <= 0;
    end else begin
        case (state)
            3'b000: // State 0
                if (data == 1'b1) begin
                    state <= 3'b001; // Transition to state 1 on '1'
                end
            3'b001: // State 1
                if (data == 1'b1) begin
                    state <= 3'b010; // Transition to state 2 on '1' after '1'
                end else begin
                    state <= 3'b000; // Reset to state 0 on '0'
                end
            3'b010: // State 2
                if (data == 1'b0) begin
                    state <= 3'b011; // Transition to state 3 on '0' after '11'
                end else begin
                    state <= 3'b000; // Reset to state 0 on '1' after '11'
                end
            3'b011: // State 3
                if (data == 1'b1) begin
                    state <= 3'b100; // Transition to state 4 on '1' after '110'
                end else begin
                    state <= 3'b000; // Reset to state 0 on '0' after '110'
                end
            3'b100: // State 4
                begin
                    state <= 3'b100; // Stay in state 4
                    start_shifting <= 1; // Set start_shifting to 1
                end
            default: 
                state <= 3'b000; // Reset to state 0
        endcase
    end
end

endmodule