module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // BYTE1
                    byte1 <= in;
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
                byte2 <= in;
            end
            2: begin // BYTE2
                state <= 0; // IDLE
                done_reg <= 1;
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    if (reset || state != 2) begin
        done_reg <= 0;
    end
end

endmodule