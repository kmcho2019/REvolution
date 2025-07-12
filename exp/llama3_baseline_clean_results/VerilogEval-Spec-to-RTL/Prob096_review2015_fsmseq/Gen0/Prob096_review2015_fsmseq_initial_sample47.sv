module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3 bits for 8 states, but we'll only use a few
parameter IDLE = 3'b000, // Initial state
             S1 = 3'b001, // Seen 1
             S11 = 3'b010, // Seen 11
             S110 = 3'b011, // Seen 110
             FOUND = 3'b100; // Seen 1101

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
                    state <= S11;
                end else begin
                    state <= IDLE;
                end
            end
            S11: begin
                if (data) begin
                    state <= S110;
                end else begin
                    state <= S1;
                end
            end
            S110: begin
                if (data) begin
                    state <= IDLE;
                end else begin
                    state <= FOUND;
                end
            end
            FOUND: begin
                start_shifting <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule