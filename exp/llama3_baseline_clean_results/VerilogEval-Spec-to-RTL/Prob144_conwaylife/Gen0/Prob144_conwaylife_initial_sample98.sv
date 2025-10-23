module TopModule(
    input               clk,
    input               load,
    input      [255:0]  data,
    output reg [255:0]  q
);

// Internal wires
wire [255:0] next_state;

// Generate next state
genvar i;
generate
    for (i = 0; i < 256; i++) begin: gen_next_state
        wire [7:0] alive_neighbors;
        
        // Count alive neighbors
        assign alive_neighbors = (
            q[(i + 256 - 16 + 1) % 256] + // Top-left
            q[(i + 256 - 16) % 256] +     // Top
            q[(i + 256 - 16 - 1) % 256] + // Top-right
            q[(i + 1) % 16 + (i / 16) * 16] + // Right
            q[(i - 1 + 16) % 16 + (i / 16) * 16] + // Left
            q[(i + 16 + 1) % 256] +         // Bottom-left
            q[(i + 16) % 256] +             // Bottom
            q[(i + 16 - 1) % 256]          // Bottom-right
        );
        
        // Update cell state
        assign next_state[i] = (
            (q[i] == 1'b1 && alive_neighbors == 2) ||
            (q[i] == 1'b0 && alive_neighbors == 3)
        );
    end
endgenerate

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_state;
    end
end

endmodule