module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 00: IDLE, 01: SEEN_1, 10: SEEN_11, 11: SEEN_110
reg       seen_1101; // flag to indicate if 1101 sequence is detected

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to IDLE state
        seen_1101 <= 1'b0;
        start_shifting <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data == 1'b1) begin
                    state <= 2'b01; // transition to SEEN_1 state
                end
            end
            2'b01: begin // SEEN_1 state
                if (data == 1'b1) begin
                    state <= 2'b10; // transition to SEEN_11 state
                end else if (data == 1'b0) begin
                    state <= 2'b00; // transition back to IDLE state
                end
            end
            2'b10: begin // SEEN_11 state
                if (data == 1'b0) begin
                    state <= 2'b11; // transition to SEEN_110 state
                end else if (data == 1'b1) begin
                    state <= 2'b10; // stay in SEEN_11 state
                end
            end
            2'b11: begin // SEEN_110 state
                if (data == 1'b1) begin
                    seen_1101 <= 1'b1; // set flag to indicate 1101 sequence detected
                end else if (data == 1'b0) begin
                    state <= 2'b00; // transition back to IDLE state
                end
            end
            default: state <= 2'b00; // default to IDLE state
        endcase
        
        if (seen_1101) begin
            start_shifting <= 1'b1; // set start_shifting to 1 when 1101 sequence is detected
        end else begin
            start_shifting <= 1'b0;
        end
    end
end

endmodule