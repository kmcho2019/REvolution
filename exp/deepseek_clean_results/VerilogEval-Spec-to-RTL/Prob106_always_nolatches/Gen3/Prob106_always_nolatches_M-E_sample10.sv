module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Check if scancode has the correct prefix (e0) first
    wire valid_prefix = (scancode[15:8] == 8'he0);
    
    // Decode the lower byte only if prefix is valid
    assign left  = valid_prefix & (scancode[7:0] == 8'h6b);
    assign down  = valid_prefix & (scancode[7:0] == 8'h72);
    assign right = valid_prefix & (scancode[7:0] == 8'h74);
    assign up    = valid_prefix & (scancode[7:0] == 8'h75);

endmodule