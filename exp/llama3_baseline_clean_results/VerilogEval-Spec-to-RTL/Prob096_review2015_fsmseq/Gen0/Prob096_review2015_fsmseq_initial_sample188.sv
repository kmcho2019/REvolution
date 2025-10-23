module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [3:0] state; // Four states for matching 1101: idle, s1, s2, s3
parameter IDLE = 0, S1 = 1, S2 = 2, S3 = 3, MATCHED = 4;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (data) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (!data) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (!data) begin
                    state <= MATCHED;
                end else begin
                    state <= IDLE;
                end
            end
            MATCHED: begin
                state <= MATCHED;
            end
        endcase
    end
end

assign start_shifting = (state == MATCHED);

endmodule