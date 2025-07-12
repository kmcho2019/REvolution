module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: RECEIVE, 2: DONE
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
        out_bytes_reg <= 24'd0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1;
                    byte1 <= in;
                end
            end
            1: begin // RECEIVE
                state <= 2;
                byte2 <= in;
            end
            2: begin // RECEIVE
                state <= 3;
                byte3 <= in;
            end
            3: begin // DONE
                state <= 0;
                done_reg <= 1;
                out_bytes_reg <= {byte1, byte2, byte3};
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        done <= 1;
        out_bytes <= out_bytes_reg;
    end else begin
        done <= 0;
        out_bytes <= 24'd0;
    end
end

endmodule