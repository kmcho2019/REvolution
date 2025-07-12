module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state;
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
        byte1 <= 0;
        byte2 <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin
                    state <= 1;
                    byte1 <= in;
                end
            end
            1: begin // BYTE1 state
                state <= 2;
                byte2 <= in;
            end
            2: begin // BYTE2 state
                state <= 0;
                out_bytes_reg <= {byte1, byte2, in};
                done_reg <= 1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else if (state == 0 && done_reg) begin
        done <= 1;
    end else begin
        done <= 0;
    end
end

assign out_bytes = out_bytes_reg;

endmodule