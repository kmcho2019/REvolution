module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Define scancode constants for each arrow key
    localparam [15:0] LEFT_CODE  = 16'he06b;
    localparam [15:0] DOWN_CODE  = 16'he072;
    localparam [15:0] RIGHT_CODE = 16'he074;
    localparam [15:0] UP_CODE    = 16'he075;

    // Parallel comparison using XOR-NOR technique
    assign left  = (scancode ^ LEFT_CODE)  == 16'b0;
    assign down  = (scancode ^ DOWN_CODE)  == 16'b0;
    assign right = (scancode ^ RIGHT_CODE) == 16'b0;
    assign up    = (scancode ^ UP_CODE)    == 16'b0;

endmodule