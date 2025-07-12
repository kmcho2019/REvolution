module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [7:0] byte1, byte2;
reg [23:0] out_bytes_reg;
reg [1:0] byte_count;

assign out_bytes = out_bytes_reg;
assign done = (byte_count == 2'b10);

always @(posedge clk) begin
    if (reset) begin
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        out_bytes_reg <= 24'd0;
        byte_count <= 2'd0;
    end else begin
        case (byte_count)
            2'd0: begin
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    byte_count <= 2'd1;
                end
            end
            2'd1: begin
                byte2 <= in;
                byte_count <= 2'd2;
            end
            2'd2: begin
                out_bytes_reg <= {in, byte2, byte1};
                byte_count <= 2'd0;
            end
        endcase
    end
end

endmodule