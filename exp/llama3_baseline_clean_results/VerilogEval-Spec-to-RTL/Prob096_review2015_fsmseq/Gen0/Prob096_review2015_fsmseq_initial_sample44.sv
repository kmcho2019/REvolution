module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state; // 0: IDLE, 1: GOT_1, 2: GOT_11, 3: GOT_110, 4: FOUND
    reg found;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            found <= 0;
            start_shifting <= 0;
        end else begin
            case (state)
                0: begin // IDLE
                    if (data) begin
                        state <= 1;
                    end else begin
                        state <= 0;
                    end
                end
                1: begin // GOT_1
                    if (data) begin
                        state <= 2;
                    end else begin
                        state <= 0;
                    end
                end
                2: begin // GOT_11
                    if (data) begin
                        state <= 2;
                    end else begin
                        state <= 3;
                    end
                end
                3: begin // GOT_110
                    if (data) begin
                        state <= 1;
                    end else begin
                        state <= 4;
                    end
                end
                4: begin // FOUND
                    start_shifting <= 1;
                end
            endcase
            if (state == 4) begin
                start_shifting <= 1;
            end else if (reset) begin
                start_shifting <= 0;
            end
        end
    end

endmodule