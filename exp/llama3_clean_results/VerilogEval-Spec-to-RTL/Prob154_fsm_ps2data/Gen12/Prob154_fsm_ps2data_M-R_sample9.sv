module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [23:0] next_out_bytes;

assign done = (byte_count == 2);
assign next_out_bytes = (byte_count == 0)? {in, 16'd0} : 
                        (byte_count == 1)? {out_bytes[23:8], in} : 
                        {out_bytes[23:8], in};

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    byte_count <= byte_count + 1;
                    out_bytes <= next_out_bytes;
                end
            end
            1: begin
                byte_count <= byte_count + 1;
                out_bytes <= next_out_bytes;
            end
            2: begin
                byte_count <= 0;
                out_bytes <= next_out_bytes;
            end
        endcase
    end
end

endmodule