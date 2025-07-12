module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // FSM state: 0 - initial, 1 - "1" matched, 2 - "11" matched, 3 - "110" matched
localparam IDLE = 2'b00;
localparam ONE_MATCHED = 2'b01;
localparam TWO_ONES_MATCHED = 2'b10;
localparam THREE_ONES_MATCHED = 2'b11;

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= ONE_MATCHED;
                end
            end
            ONE_MATCHED: begin
                if (data) begin
                    state <= TWO_ONES_MATCHED;
                end else begin
                    state <= IDLE;
                end
            end
            TWO_ONES_MATCHED: begin
                if (!data) begin
                    state <= THREE_ONES_MATCHED;
                end else begin
                    state <= ONE_MATCHED;
                end
            end
            THREE_ONES_MATCHED: begin
                if (data) begin
                    state <= IDLE; // Incorrect sequence, return to initial state
                end else begin
                    start_shifting <= 1; // Full sequence matched, set start_shifting
                end
            end
            default: state <= IDLE; // Invalid state, reset to initial state
        endcase
    end
end

endmodule