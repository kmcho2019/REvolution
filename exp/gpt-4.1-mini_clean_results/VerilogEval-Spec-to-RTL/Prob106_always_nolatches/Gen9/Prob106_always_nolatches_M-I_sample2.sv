module TopModule (
    input  [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Internal 4-bit signal encoding which arrow key is pressed
    // Bit order: [3] up, [2] right, [1] down, [0] left
    reg [3:0] arrow_enc;

    always @* begin
        case (scancode)
            16'he06b: arrow_enc = 4'b0001; // left
            16'he072: arrow_enc = 4'b0010; // down
            16'he074: arrow_enc = 4'b0100; // right
            16'he075: arrow_enc = 4'b1000; // up
            default:  arrow_enc = 4'b0000; // none
        endcase
    end

    assign left  = arrow_enc[0];
    assign down  = arrow_enc[1];
    assign right = arrow_enc[2];
    assign up    = arrow_enc[3];

endmodule