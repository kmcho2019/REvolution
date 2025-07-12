module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 2-bit state register

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state 0
        start_shifting <= 0;
    end else begin
        case (state)
            2'b00: // State 0
                if (data == 1'b1) begin
                    state <= 2'b01; // Transition to state 1 on '1'
                end
            2'b01: // State 1
                if (data == 1'b1) begin
                    state <= 2'b10; // Transition to state 2 on '1' after '1'
                end else begin
                    state <= 2'b00; // Reset to state 0 on '0'
                end
            2'b10: // State 2
                if (data == 1'b1) begin
                    state <= 2'b11; // Transition to state 3 on '1' after '110'
                end else begin
                    state <= 2'b00; // Reset to state 0 on '0' after '110'
                end
            2'b11: // State 3
                begin
                    state <= 2'b11; // Stay in state 3
                    start_shifting <= 1; // Keep start_shifting at 1
                end
        endcase
    end
end

endmodule