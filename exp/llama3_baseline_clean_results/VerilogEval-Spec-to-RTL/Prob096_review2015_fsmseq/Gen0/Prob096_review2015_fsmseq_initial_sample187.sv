module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // 00: idle, 01: received 1, 10: received 11, 11: received 110
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data) begin
                    state <= 1; // received 1
                end
            end
            1: begin // received 1
                if (data) begin
                    state <= 2; // received 11
                end else begin
                    state <= 0; // received 10, not a match
                end
            end
            2: begin // received 11
                if (!data) begin
                    state <= 3; // received 110
                end else begin
                    state <= 1; // received 111, not a match
                end
            end
            3: begin // received 110
                if (!data) begin
                    start_shifting_reg <= 1; // received 1101, set start_shifting
                end else begin
                    state <= 1; // received 1101, not a match
                end
            end
            default: begin
                if (!data) begin
                    state <= 0; // not a match
                end
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule