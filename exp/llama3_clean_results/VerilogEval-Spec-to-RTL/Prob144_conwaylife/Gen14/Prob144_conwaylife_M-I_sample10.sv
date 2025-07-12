module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(*) begin
    for (int i = 0; i < 256; i++) begin
        reg [7:0] neighbors;
        neighbors[0] = q[((i % 16) - 1 + 16) % 16 + ((i / 16) - 1 + 16) % 16 * 16];
        neighbors[1] = q[((i % 16) + 0 + 16) % 16 + ((i / 16) - 1 + 16) % 16 * 16];
        neighbors[2] = q[((i % 16) + 1 + 16) % 16 + ((i / 16) - 1 + 16) % 16 * 16];
        neighbors[3] = q[((i % 16) - 1 + 16) % 16 + ((i / 16) + 0 + 16) % 16 * 16];
        neighbors[4] = q[((i % 16) + 0 + 16) % 16 + ((i / 16) + 0 + 16) % 16 * 16];
        neighbors[5] = q[((i % 16) + 1 + 16) % 16 + ((i / 16) + 0 + 16) % 16 * 16];
        neighbors[6] = q[((i % 16) - 1 + 16) % 16 + ((i / 16) + 1 + 16) % 16 * 16];
        neighbors[7] = q[((i % 16) + 0 + 16) % 16 + ((i / 16) + 1 + 16) % 16 * 16];

        case ({neighbors[7], neighbors[6], neighbors[5], neighbors[4], neighbors[3], neighbors[2], neighbors[1], neighbors[0]})
            8'b00000000, 8'b00000001: next_q[i] = 0;
            8'b00000010: next_q[i] = q[i];
            8'b00000100: next_q[i] = 1;
            default: next_q[i] = 0;
        endcase
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule