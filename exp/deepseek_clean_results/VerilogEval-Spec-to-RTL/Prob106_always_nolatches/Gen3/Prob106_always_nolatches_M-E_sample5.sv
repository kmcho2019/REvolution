module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Treat the scancode as an address into a virtual ROM
    // Each entry is a 4-bit vector {left, down, right, up}
    reg [3:0] arrow_keys;
    
    always @(*) begin
        case (scancode)
            16'he06b: arrow_keys = 4'b1000; // left
            16'he072: arrow_keys = 4'b0100; // down
            16'he074: arrow_keys = 4'b0010; // right
            16'he075: arrow_keys = 4'b0001; // up
            default:  arrow_keys = 4'b0000; // none
        endcase
    end

    assign {left, down, right, up} = arrow_keys;

endmodule