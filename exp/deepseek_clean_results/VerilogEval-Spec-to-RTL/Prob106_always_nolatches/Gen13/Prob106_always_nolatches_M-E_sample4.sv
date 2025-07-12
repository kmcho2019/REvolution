module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Define the expected scancodes for each arrow key
localparam LEFT_CODE  = 16'he06b;
localparam DOWN_CODE  = 16'he072;
localparam RIGHT_CODE = 16'he074;
localparam UP_CODE    = 16'he075;

// Pattern matching using XOR (result is 0 when match occurs)
assign left  = (scancode ^ LEFT_CODE)  == 16'b0;
assign down  = (scancode ^ DOWN_CODE)  == 16'b0;
assign right = (scancode ^ RIGHT_CODE) == 16'b0;
assign up    = (scancode ^ UP_CODE)    == 16'b0;

endmodule