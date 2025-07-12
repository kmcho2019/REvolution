module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    wire d = ~a; // This wire remains for clarity but could be folded into the DFF instantiation

    // Instead of externally inverting 'a', directly feed inverted 'a' to the DFF.
    DFF dff_inst (
        .clk(clk),
        .d(~a),  // inversion moved here, inside input to DFF
        .q(q)
    );
endmodule