module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Load data into q at the next clock edge
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

// Calculate next_q
genvar i;
generate
    for (i = 0; i < 256; i++) begin
        wire [7:0] neighbors;
        // Calculate the number of live neighbors
        assign neighbors = (
            q[((i + 16 - 1) % 16) + ((i / 16) * 16)] +
            q[((i + 1) % 16) + ((i / 16) * 16)] +
            q[((i + 16 + 1) % 16) + (((i / 16) + 1) % 16 * 16)] +
            q[(i - 1) + ((i / 16) * 16)] +
            q[i] +
            q[((i + 1) % 16) + ((i / 16) * 16)] +
            q[((i - 1) + 16) % 16 + (((i / 16) + 1) % 16 * 16)] +
            q[((i - 1) + 16) % 16 + ((i / 16) * 16)]
        );
        // Apply the game rules based on the number of live neighbors
        always @(q) begin
            case(neighbors)
                8'b00000001, 8'b00000010: next_q[i] <= 1'b0;
                8'b00000100: next_q[i] <= q[i];
                8'b00000110: next_q[i] <= 1'b1;
                default: next_q[i] <= 1'b0;
            endcase
        end
    end
endgenerate

endmodule