module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Initialize the current state q with the input data when the load signal is high
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

// Calculate the number of neighbors for each cell in the 16x16 grid
genvar i, j;
generate
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            wire [7:0] neighbors;
            assign neighbors[0] = q[((i - 1 + 16) % 16) * 16 + ((j - 1 + 16) % 16)];
            assign neighbors[1] = q[((i - 1 + 16) % 16) * 16 + j];
            assign neighbors[2] = q[((i - 1 + 16) % 16) * 16 + ((j + 1) % 16)];
            assign neighbors[3] = q[i * 16 + ((j - 1 + 16) % 16)];
            assign neighbors[4] = q[i * 16 + ((j + 1) % 16)];
            assign neighbors[5] = q[((i + 1) % 16) * 16 + ((j - 1 + 16) % 16)];
            assign neighbors[6] = q[((i + 1) % 16) * 16 + j];
            assign neighbors[7] = q[((i + 1) % 16) * 16 + ((j + 1) % 16)];

            // Update the state of each cell based on the number of its neighbors
            always @(*) begin
                case ({neighbors[0], neighbors[1], neighbors[2], neighbors[3], neighbors[4], neighbors[5], neighbors[6], neighbors[7]})
                    8'b00000000, 8'b00000001: next_q[i * 16 + j] = 0;
                    8'b00000010, 8'b00000100, 8'b00001000, 8'b00010000, 8'b00100000, 8'b01000000, 8'b10000000: next_q[i * 16 + j] = q[i * 16 + j];
                    8'b00000110, 8'b00001100, 8'b00010100, 8'b00101000, 8'b00110000, 8'b01001000, 8'b01010000, 8'b01100000, 8'b10000100, 8'b10001000, 8'b10010000, 8'b10100000, 8'b11000000: next_q[i * 16 + j] = 1;
                    default: next_q[i * 16 + j] = 0;
                endcase
            end
        end
    end
endgenerate

endmodule