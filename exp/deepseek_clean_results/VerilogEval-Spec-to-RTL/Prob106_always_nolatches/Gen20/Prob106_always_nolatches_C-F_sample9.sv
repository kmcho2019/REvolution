module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

// Use casez for flexible pattern matching
reg [3:0] arrow_keys;
always @(*) begin
    casez (scancode)
        16'he06b: arrow_keys = 4'b1000; // left
        16'he072: arrow_keys = 4'b0100; // down
        16'he074: arrow_keys = 4'b0010; // right
        16'he075: arrow_keys = 4'b0001; // up
        default:   arrow_keys = 4'b0000; // none
    endcase
end

// Assign outputs from one-hot encoded register
assign {left, down, right, up} = arrow_keys;

endmodule