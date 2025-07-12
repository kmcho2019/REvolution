module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline stage 1 registers: store neighbors for each cell
    reg [511:0] left_reg;
    reg [511:0] center_reg;
    reg [511:0] right_reg;

    // Intermediate wires for neighbors on combinational stage
    wire [511:0] left_next;
    wire [511:0] center_next;
    wire [511:0] right_next;

    // Boundary conditions: neighbors outside are zero
    // left neighbor = q[i+1] if i<511 else 0
    assign left_next[511:0]  = {q[510:0], 1'b0};
    // center neighbor = q[i]
    assign center_next       = q;
    // right neighbor = q[i-1] if i>0 else 0
    assign right_next[511:0] = {1'b0, q[511:1]};

    // Update stage 1 pipeline registers: latch neighbors on clk if not loading
    // When load is high, neighbors pipeline is invalid and bypassed.
    always @(posedge clk) begin
        if (load) begin
            // Don't update pipeline registers, they'll be invalid this cycle.
            left_reg   <= 512'b0;
            center_reg <= 512'b0;
            right_reg  <= 512'b0;
        end else begin
            left_reg   <= left_next;
            center_reg <= center_next;
            right_reg  <= right_next;
        end
    end

    // Rule 110 truth table (input: {left,center,right}, output next state)
    // Encoded as 3-bit index: {L,C,R}
    // Table:
    // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0
    // Implemented as combinational function:
    // next = (~left & center) | (center ^ right)

    // Compute next state on pipeline stage 2 from registered neighbors
    wire [511:0] next_state;
    genvar i;
    generate
        for (i=0; i<512; i=i+1) begin : next_compute
            wire l = left_reg[i];
            wire c = center_reg[i];
            wire r = right_reg[i];
            assign next_state[i] = (~l & c) | (c ^ r);
        end
    endgenerate

    // Final output register update
    // If load is high, load data directly
    // else update q with next_state (which is pipeline stage 2 output)
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule