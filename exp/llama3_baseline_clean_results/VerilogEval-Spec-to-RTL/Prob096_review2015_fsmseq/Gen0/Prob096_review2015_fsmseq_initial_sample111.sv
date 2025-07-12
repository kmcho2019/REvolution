module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // state machine states: 3'b000 - IDLE, 3'b001 - SEEN1, 3'b010 - SEEN11, 3'b011 - SEEN110, 3'b100 - SEEN1101

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // reset to IDLE state
        start_shifting <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (data) begin
                    state <= 3'b001; // move to SEEN1 state
                end
            end
            3'b001: begin // SEEN1 state
                if (data) begin
                    state <= 3'b010; // move to SEEN11 state
                end else begin
                    state <= 3'b000; // return to IDLE state
                end
            end
            3'b010: begin // SEEN11 state
                if (data) begin
                    state <= 3'b010; // stay in SEEN11 state
                end else begin
                    state <= 3'b011; // move to SEEN110 state
                end
            end
            3'b011: begin // SEEN110 state
                if (data) begin
                    state <= 3'b100; // move to SEEN1101 state
                    start_shifting <= 1'b1;
                end else begin
                    state <= 3'b000; // return to IDLE state
                end
            end
            3'b100: begin // SEEN1101 state
                start_shifting <= 1'b1; // stay in SEEN1101 state
            end
        endcase
    end
end

endmodule