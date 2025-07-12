module TopModule(
    input [3:0] x,  // x[3]x[4]x[1]x[2] mapping
    output f
);

    // Correct bit mapping: {x[3],x[4]} for rows, {x[1],x[2]} for columns
    assign f = (
        // Cases where f=1 (including resolved don't-cares)
        ({x[3],x[0]} == 2'b00 && {x[1],x[2]} == 2'b00) ||  // Resolved don't-care to 1
        ({x[3],x[0]} == 2'b00 && {x[1],x[2]} == 2'b11) ||  // Resolved don't-care to 1
        ({x[3],x[0]} == 2'b00 && {x[1],x[2]} == 2'b10) ||  // Resolved don't-care to 1
        ({x[3],x[0]} == 2'b01 && {x[1],x[2]} == 2'b01) ||  // Resolved don't-care to 1
        ({x[3],x[0]} == 2'b01 && {x[1],x[2]} == 2'b11) ||  // Mandatory 1
        ({x[3],x[0]} == 2'b11 && {x[1],x[2]} == 2'b00) ||  // Mandatory 1
        ({x[3],x[0]} == 2'b11 && {x[1],x[2]} == 2'b01) ||  // Mandatory 1
        ({x[3],x[0]} == 2'b11 && {x[1],x[2]} == 2'b11) ||  // Resolved don't-care to 1
        ({x[3],x[0]} == 2'b11 && {x[1],x[2]} == 2'b10) ||  // Resolved don't-care to 1
        ({x[3],x[0]} == 2'b10 && {x[1],x[2]} == 2'b00) ||  // Mandatory 1
        ({x[3],x[0]} == 2'b10 && {x[1],x[2]} == 2'b01)     // Mandatory 1
    ) && !(
        // Cases where f=0 (overrides the above if both match)
        ({x[3],x[0]} == 2'b00 && {x[1],x[2]} == 2'b01) ||  // Mandatory 0
        ({x[3],x[0]} == 2'b01 && {x[1],x[2]} == 2'b00) ||  // Mandatory 0
        ({x[3],x[0]} == 2'b01 && {x[1],x[2]} == 2'b10) ||  // Mandatory 0
        ({x[3],x[0]} == 2'b10 && {x[1],x[2]} == 2'b11)     // Mandatory 0
    );

endmodule