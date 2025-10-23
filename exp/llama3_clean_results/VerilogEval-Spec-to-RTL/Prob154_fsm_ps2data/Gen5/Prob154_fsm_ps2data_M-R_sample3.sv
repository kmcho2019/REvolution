module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output reg done
);

reg [23:0] out_bytes_reg;
enum logic [1:0] {idle, byte1, byte2, done_state} state;

always @(posedge clk) begin
    if (reset) begin
        out_bytes_reg <= 24'd0;
        state <= idle;
        done <= 1'b0;
    end else begin
        case (state)
            idle: begin
                if (in[3] == 1'b1) begin
                    out_bytes_reg <= {in, 16'd0};
                    state <= byte1;
                end
            end
            byte1: begin
                out_bytes_reg <= {out_bytes_reg[15:0], in};
                state <= byte2;
            end
            byte2: begin
                out_bytes_reg <= {out_bytes_reg[7:0], in, 8'd0};
                state <= done_state;
            end
            done_state: begin
                done <= 1'b1;
                state <= idle;
            end
        endcase
    end
end

assign out_bytes = (state == done_state)? out_bytes_reg : 24'bx;

always @(posedge clk) begin
    if (!reset && state != done_state) begin
        done <= 1'b0;
    end
end

endmodule