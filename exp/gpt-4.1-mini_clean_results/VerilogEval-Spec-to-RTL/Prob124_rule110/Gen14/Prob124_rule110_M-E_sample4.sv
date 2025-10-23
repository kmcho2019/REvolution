module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline stage registers for neighbors
    reg [511:0] left_reg;
    reg [511:0] center_reg;
    reg [511:0] right_reg;

    // Pipeline stage register for next state
    reg [511:0] next_q_reg;

    // Neighbor extraction with zero padding:
    // left neighbors: q shifted left by 1, leftmost zero
    wire [511:0] left = {q[510:0], 1'b0};
    // right neighbors: q shifted right by 1, rightmost zero
    wire [511:0] right = {1'b0, q[511:1]};
    // center: the current q
    wire [511:0] center = q;

    // Rule 110 logic function applied vectorially
    // next state = (~left & center) | (center ^ right)
    // all bitwise vector operations
    wire [511:0] next_q = (~left_reg & center_reg) | (center_reg ^ right_reg);

    always @(posedge clk) begin
        if (load) begin
            // Load new initial data and clear pipeline registers
            q <= data;
            left_reg <= 512'd0;
            center_reg <= 512'd0;
            right_reg <= 512'd0;
            next_q_reg <= 512'd0;
        end else begin
            // Shift pipeline stages
            // Stage 1: latch neighbors from current state q
            left_reg <= left;
            center_reg <= center;
            right_reg <= right;

            // Stage 2: latch next state computed from neighbors
            next_q_reg <= next_q;

            // Update main register q from second pipeline stage
            q <= next_q_reg;
        end
    end

endmodule