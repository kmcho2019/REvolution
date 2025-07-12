module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Common prefix check (E0)
    wire is_arrow_prefix = (scancode[15:8] == 8'he0);
    
    // Individual arrow key suffix checks
    assign left  = is_arrow_prefix & ~|(scancode[7:0] ^ 8'h6b);
    assign down  = is_arrow_prefix & ~|(scancode[7:0] ^ 8'h72);
    assign right = is_arrow_prefix & ~|(scancode[7:0] ^ 8'h74);
    assign up    = is_arrow_prefix & ~|(scancode[7:0] ^ 8'h75);

endmodule