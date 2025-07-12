module TopModule(
    input        clk,
    input        reset,
    input        data,
    output       start_shifting
);

reg [2:0] state; // 3 bits to represent 5 states (IDLE, SEEN1, SEEN11, SEEN110, SEEN1101)
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data) begin
                    state <= 1; // SEEN1 state
                end else begin
                    state <= 0; // IDLE state
                end
            end
            1: begin // SEEN1 state
                if (data) begin
                    state <= 2; // SEEN11 state
                end else begin
                    state <= 3; // SEEN10 state (not needed, but for completeness)
                end
            end
            2: begin // SEEN11 state
                if (data) begin
                    state <= 2; // SEEN11 state
                end else begin
                    state <= 4; // SEEN110 state
                end
            end
            3: begin // SEEN10 state (not needed, but for completeness)
                if (data) begin
                    state <= 1; // SEEN1 state
                end else begin
                    state <= 0; // IDLE state
                end
            end
            4: begin // SEEN110 state
                if (data) begin
                    state <= 1; // SEEN1 state
                end else begin
                    state <= 5; // SEEN1101 state
                    start_shifting_reg <= 1;
                end
            end
            default: begin // SEEN1101 state
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule