module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: initial, 1: byte1, 2: byte2, 3: byte3
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // initial state
                if (in[3]) begin
                    state <= 1;
                end
            end
            1: begin // byte1 state
                state <= 2;
            end
            2: begin // byte2 state
                state <= 3;
            end
            3: begin // byte3 state
                state <= 0;
                done_reg <= 1;
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else begin
        done <= done_reg;
        done_reg <= 0;
    end
end

endmodule