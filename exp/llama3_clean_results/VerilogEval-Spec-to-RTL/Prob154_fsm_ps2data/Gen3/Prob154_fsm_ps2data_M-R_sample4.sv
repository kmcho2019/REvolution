module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output reg done
);

reg [7:0] byte1, byte2;
reg [23:0] out_bytes_reg;
reg [1:0] byte_count;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        out_bytes_reg <= 24'd0;
        byte_count <= 2'd0;
        state <= 2'd0;
        done <= 1'b0;
    end else begin
        case (state)
            2'd0: begin
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'd1;
                    byte_count <= 2'd1;
                end
            end
            2'd1: begin
                byte2 <= in;
                state <= 2'd2;
                byte_count <= 2'd2;
            end
            2'd2: begin
                out_bytes_reg <= {in, byte2, byte1};
                state <= 2'd0;
                byte_count <= 2'd0;
                done <= 1'b1;
            end
        endcase
    end
end

assign out_bytes = (done) ? out_bytes_reg : 24'bx;

always @(posedge clk) begin
    if (!reset && state == 2'd0) begin
        done <= 1'b0;
    end
end

endmodule