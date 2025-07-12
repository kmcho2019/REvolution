module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Shared extended key detection
    wire is_arrow_key = (scancode[15:8] == 8'he0);
    
    // Parallel output assignments with optimized comparisons
    assign left  = is_arrow_key & (scancode[7:0] == 8'h6b);
    assign down  = is_arrow_key & (scancode[7:0] == 8'h72);
    assign right = is_arrow_key & (scancode[7:0] == 8'h74);
    assign up    = is_arrow_key & (scancode[7:0] == 8'h75);

endmodule