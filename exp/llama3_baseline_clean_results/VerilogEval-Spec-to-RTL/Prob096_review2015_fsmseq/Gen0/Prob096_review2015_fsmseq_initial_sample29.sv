module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits for 4 states

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (data) begin
                    state <= 1; // Move to S1
                end else begin
                    state <= 0; // Stay in S0
                end
            end
            1: begin // S1
                if (data) begin
                    state <= 2; // Move to S2
                end else begin
                    state <= 0; // Move back to S0
                end
            end
            2: begin // S2
                if (~data) begin
                    state <= 3; // Move to S3
                end else begin
                    state <= 1; // Move back to S1
                end
            end
            3: begin // S3
                if (data) begin
                    state <= 4; // Move to S4
                    start_shifting <= 1;
                end else begin
                    state <= 0; // Move back to S0
                end
            end
            4: begin // S4
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule