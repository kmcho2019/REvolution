module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Define the arrow key patterns as bitmasks
localparam LEFT_MASK  = 16'he06b;
localparam DOWN_MASK  = 16'he072;
localparam RIGHT_MASK = 16'he074;
localparam UP_MASK    = 16'he075;

// Parallel equality checks using XOR-NOR pattern matching
wire match_left  = (scancode ^ LEFT_MASK)  == 16'h0000;
wire match_down  = (scancode ^ DOWN_MASK)  == 16'h0000;
wire match_right = (scancode ^ RIGHT_MASK) == 16'h0000;
wire match_up    = (scancode ^ UP_MASK)    == 16'h0000;

// Direct output assignments (mutually exclusive by definition)
assign left  = match_left;
assign down  = match_down;
assign right = match_right;
assign up    = match_up;

endmodule