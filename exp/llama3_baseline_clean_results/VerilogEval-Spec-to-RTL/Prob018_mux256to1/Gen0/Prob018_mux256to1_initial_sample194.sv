module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

always @(*) begin
    case (sel)
        8'd0: out = in[0];
        8'd1: out = in[1];
        8'd2: out = in[2];
        // ... (this is not a good way, we need a more general solution)
        // Instead of writing 256 cases, we can use the following approach:
        default: out = in[sel];
    endcase
end

// A better solution without using case statement would be:
// always @(*) begin
//     out = in[sel];
// end

endmodule