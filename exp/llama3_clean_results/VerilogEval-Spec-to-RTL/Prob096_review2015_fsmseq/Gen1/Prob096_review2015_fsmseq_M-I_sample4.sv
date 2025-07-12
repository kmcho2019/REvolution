module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 0: Idle, 1: Seen 1, 2: Seen 11, 3: Seen 110, 4: Seen 1101, 5: Shift

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // Seen 1
                if (data) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // Seen 11
                if (~data) begin
                    state <= 3;
                end else begin
                    state <= 1; // Corrected transition logic
                end
            end
            3: begin // Seen 110
                if (data) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin // Seen 1101
                state <= 5; // Immediate transition to Shift state
                start_shifting <= 1;
            end
            5: begin // Shift
                if (~reset) begin // To ensure start_shifting remains 1 until reset
                    start_shifting <= 1;
                end else begin
                    start_shifting <= 0;
                end
            end
        endcase
    end
end

endmodule