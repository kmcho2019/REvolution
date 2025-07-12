module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] next_state;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(*) begin
    case(state)
        2'b00: begin // Idle
            if (in[3] == 1) begin
                next_state = 2'b01;
                out_bytes_reg = {in, 16'd0};
            end else begin
                next_state = 2'b00;
                out_bytes_reg = out_bytes_reg;
            end
        end
        2'b01: begin // Byte1
            next_state = 2'b10;
            out_bytes_reg = {in, out_bytes_reg[15:0]};
        end
        2'b10: begin // Byte2
            next_state = 2'b11;
            out_bytes_reg = {out_bytes_reg[23:8], in};
        end
        2'b11: begin // Byte3
            next_state = 2'b00;
            out_bytes_reg = out_bytes_reg;
            done_reg = 1'b1;
        end
        default: begin
            next_state = 2'b00;
            out_bytes_reg = out_bytes_reg;
            done_reg = 1'b0;
        end
    endcase

    if (reset == 1'b1) begin
        next_state = 2'b00;
        out_bytes_reg = 24'd0;
        done_reg = 1'b0;
    end
end

always @(posedge clk) begin
    state <= next_state;
    out_bytes <= out_bytes_reg;
    done <= done_reg;
end

endmodule