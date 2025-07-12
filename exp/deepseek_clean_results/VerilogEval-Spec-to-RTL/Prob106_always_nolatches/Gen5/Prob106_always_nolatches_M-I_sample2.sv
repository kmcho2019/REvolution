module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // PS/2 scancode decoding for arrow keys
    // Extended keys have 0xE0 prefix followed by key code
    // Using continuous assignments for better optimization
    assign left  = (scancode == 16'he06b);
    assign down  = (scancode == 16'he072);
    assign right = (scancode == 16'he074);
    assign up    = (scancode == 16'he075);

    // Alternative implementation using case statement for reference:
    /*
    always @(*) begin
        case (scancode)
            16'he06b: {left, down, right, up} = 4'b1000;
            16'he072: {left, down, right, up} = 4'b0100;
            16'he074: {left, down, right, up} = 4'b0010;
            16'he075: {left, down, right, up} = 4'b0001;
            default:  {left, down, right, up} = 4'b0000;
        endcase
    end
    */

endmodule