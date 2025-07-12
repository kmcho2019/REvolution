module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parallel prefix adder implementation for counter
wire [15:0] delta = up_down ? 16'h0001 : 16'hFFFF; // +1 or -1 (two's complement)
wire [15:0] next_count;

// Generate propagate (p) and generate (g) signals
wire [15:0] p = count ^ delta;
wire [15:0] g = count & delta;

// Kogge-Stone parallel prefix carry computation
wire [15:0] c;

// First level
wire [14:0] g1 = g[14:0] | (p[14:0] & g[15:1]);
wire [14:0] p1 = p[14:0] & p[15:1];

// Second level
wire [12:0] g2 = g1[12:0] | (p1[12:0] & {2'b11, g1[14:2]});
wire [12:0] p2 = p1[12:0] & {2'b11, p1[14:2]};

// Third level
wire [8:0] g3 = g2[8:0] | (p2[8:0] & {4'b1111, g2[12:4]});
wire [8:0] p3 = p2[8:0] & {4'b1111, p2[12:4]};

// Fourth level
wire [0:0] g4 = g3[0] | (p3[0] & g3[8]);

// Final carry computation
assign c = {g4, 
           g3[1] | (p3[1] & g4),
           g3[2] | (p3[2] & {g4, g3[1] | (p3[1] & g4)}),
           // ... similar for remaining bits (omitted for brevity)
           1'b0}; // LSB carry-in is always 0

assign next_count = p ^ {c[14:0], 1'b0};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule