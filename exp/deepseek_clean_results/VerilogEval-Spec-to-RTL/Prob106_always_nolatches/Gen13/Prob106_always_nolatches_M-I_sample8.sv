module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Direct combinational decoding
    always @(*) begin
        case (scancode)
            16'he06b: {left, down, right, up} = 4'b1000; // left
            16'he072: {left, down, right, up} = 4'b0100; // down
            16'he074: {left, down, right, up} = 4'b0010; // right
            16'he075: {left, down, right, up} = 4'b0001; // up
            default:  {left, down, right, up} = 4'b0000;  // none
        endcase
    end

endmodule