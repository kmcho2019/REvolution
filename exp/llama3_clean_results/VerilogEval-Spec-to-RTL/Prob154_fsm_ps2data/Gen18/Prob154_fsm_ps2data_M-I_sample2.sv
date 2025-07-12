module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [23:0] out_bytes_next;
reg done_next;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    out_bytes_next = {in, 16'b0};
                    state <= 2'b01;
                    done_next = 1'b0;
                end else begin
                    out_bytes_next = out_bytes;
                    state <= 2'b00;
                    done_next = 1'b0;
                end
            end
            2'b01: begin
                out_bytes_next = {out_bytes[23:8], in, 8'b0};
                state <= 2'b10;
                done_next = 1'b0;
            end
            2'b10: begin
                out_bytes_next = {out_bytes[23:8], in};
                state <= 2'b00;
                done_next = 1'b1;
            end
            default: begin
                state <= 2'b00;
                done_next = 1'b0;
            end
        endcase
        out_bytes <= out_bytes_next;
        done <= done_next;
    end
end

endmodule