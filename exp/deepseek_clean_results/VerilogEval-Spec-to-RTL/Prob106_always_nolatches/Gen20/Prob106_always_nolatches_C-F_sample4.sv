module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Define the scancode patterns for each arrow key
localparam [15:0] LEFT_PAT  = 16'he06b;
localparam [15:0] DOWN_PAT  = 16'he072;
localparam [15:0] RIGHT_PAT = 16'he074;
localparam [15:0] UP_PAT    = 16'he075;

// Parallel pattern matching using XOR and NOR
wire left_match  = ~|(scancode ^ LEFT_PAT);
wire down_match  = ~|(scancode ^ DOWN_PAT);
wire right_match = ~|(scancode ^ RIGHT_PAT);
wire up_match    = ~|(scancode ^ UP_PAT);

// One-hot output encoding
assign {left, down, right, up} = {left_match, down_match, right_match, up_match};

endmodule