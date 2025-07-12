module TopModule(
    input           clk,
    input           reset,
    input           data,
    output reg      start_shifting
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            start_shifting <= 0;
        end else begin
            case (state)
                0: begin // S0
                    if (data == 1) begin
                        state <= 1;
                    end else begin
                        state <= 0;
                    end
                end
                1: begin // S1
                    if (data == 1) begin
                        state <= 2;
                    end else if (data == 0) begin
                        state <= 0;
                    end else begin
                        state <= 1;
                    end
                end
                2: begin // S2
                    if (data == 0) begin
                        state <= 3;
                    end else if (data == 1) begin
                        state <= 1;
                    end else begin
                        state <= 2;
                    end
                end
                3: begin // S3
                    if (data == 1) begin
                        state <= 4;
                        start_shifting <= 1;
                    end else if (data == 0) begin
                        state <= 0;
                    end else begin
                        state <= 3;
                    end
                end
                default: begin // S4
                    state <= 4;
                end
            endcase
        end
    end

endmodule