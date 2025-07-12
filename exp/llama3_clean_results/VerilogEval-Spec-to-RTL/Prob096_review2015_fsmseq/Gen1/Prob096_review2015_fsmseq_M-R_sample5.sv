module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // idle (0), saw_1 (1), saw_11 (2), saw_110 (3), saw_1101 (4)

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // idle
    end else begin
        case(state)
            3'b000: begin // idle
                if (data) begin
                    state <= 3'b001; // saw_1
                end else begin
                    state <= 3'b000; // idle
                end
            end
            3'b001: begin // saw_1
                if (data) begin
                    state <= 3'b010; // saw_11
                end else begin
                    state <= 3'b000; // idle
                end
            end
            3'b010: begin // saw_11
                if (data) begin
                    state <= 3'b011; // saw_110
                end else begin
                    state <= 3'b001; // saw_1
                end
            end
            3'b011: begin // saw_110
                if (data) begin
                    state <= 3'b000; // idle
                end else begin
                    state <= 3'b100; // saw_1101
                end
            end
            3'b100: begin // saw_1101
                state <= 3'b100; // stay in this state
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 1'b0;
    end else if (state == 3'b100) begin
        start_shifting <= 1'b1;
    end
end

endmodule