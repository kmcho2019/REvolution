module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register for 4 states: IDLE, S1, S2, S3, S4
parameter IDLE = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (!data) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
            end
            S3: begin
                if (data) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                state <= S4; // Stay in S4 state
            end
        endcase
        if (state == S4) begin
            start_shifting <= 1;
        end else if (state != S4 && start_shifting) begin
            start_shifting <= 0; // Reset start_shifting if not in S4 state and it was previously set
        end
    end
end

endmodule