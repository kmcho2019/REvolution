module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

always @(*) begin
    case (sel)
        8'b0: out = in[0];
        8'b1: out = in[1];
        8'b2: out = in[2];
        // ... and so on for all 256 possibilities ...
        // However, for simplicity and efficiency, we can directly use the sel value to index into the in vector
        default: out = in[sel];
    endcase
end

// The above always block can be simplified as:
// always @(*) begin
//     out = in[sel];
// end

// This simplified version achieves the same functionality without needing a large case statement.

endmodule