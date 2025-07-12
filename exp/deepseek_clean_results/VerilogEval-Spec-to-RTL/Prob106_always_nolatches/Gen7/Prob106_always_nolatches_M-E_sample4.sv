module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Internal 4-bit vector for ROM output
    reg [3:0] arrow_keys;
    
    // ROM implementation as a case statement
    always @(*) begin
        case (scancode)
            16'he06b: arrow_keys = 4'b1000; // left
            16'he072: arrow_keys = 4'b0100; // down
            16'he074: arrow_keys = 4'b0010; // right
            16'he075: arrow_keys = 4'b0001; // up
            default:  arrow_keys = 4'b0000; // none
        endcase
    end
    
    // Assign outputs from the ROM bits
    assign left  = arrow_keys[3];
    assign down  = arrow_keys[2];
    assign right = arrow_keys[1];
    assign up    = arrow_keys[0];

endmodule