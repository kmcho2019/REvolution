module TopModule(clk, reset, s, w, z);
    input clk, reset, s, w;
    output z;
    reg z;
    reg [1:0] state; // 0 - state A, 1 - state B
    reg [1:0] counter; // Counter for the three clock cycles
    reg [1:0] w_count; // Counter for w = 1

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            z <= 0;
            counter <= 0;
            w_count <= 0;
        end else begin
            case (state)
                0: begin // State A
                    if (s) begin
                        state <= 1;
                        counter <= 1;
                        w_count <= w;
                    end else begin
                        state <= 0;
                    end
                end
                1: begin // State B
                    if (counter == 3) begin
                        if (w_count == 2) begin
                            z <= 1;
                        end else begin
                            z <= 0;
                        end
                        state <= 1;
                        counter <= 1;
                        w_count <= w;
                    end else begin
                        state <= 1;
                        counter <= counter + 1;
                        w_count <= w_count + w;
                    end
                end
            endcase
        end
    end
endmodule