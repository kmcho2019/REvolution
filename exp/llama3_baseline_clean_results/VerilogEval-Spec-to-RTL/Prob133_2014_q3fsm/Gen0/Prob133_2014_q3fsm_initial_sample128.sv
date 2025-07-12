module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // state A (0) and state B (1)
reg [1:0] sub_state; // sub-states B1 (0), B2 (1), and B3 (2)
reg [1:0] w_count; // counter for w = 1

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        sub_state <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1;
                    sub_state <= 0;
                    w_count <= 0;
                end
            end
            1: begin // state B
                case (sub_state)
                    0: begin // sub-state B1
                        if (w) begin
                            w_count <= w_count + 1;
                        end
                        sub_state <= 1;
                    end
                    1: begin // sub-state B2
                        if (w) begin
                            w_count <= w_count + 1;
                        end
                        sub_state <= 2;
                    end
                    2: begin // sub-state B3
                        if (w) begin
                            w_count <= w_count + 1;
                        end
                        sub_state <= 0;
                        if (w_count == 2) begin
                            z <= 1;
                        end else begin
                            z <= 0;
                        end
                        w_count <= 0;
                    end
                endcase
            end
        endcase
    end
end

endmodule