module DFF_invert_d (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= ~d; // Internal inversion before storing
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Instantiate the DFF that captures inverted input internally
    DFF_invert_d dff_inst (
        .clk(clk),
        .d(a),
        .q(q)
    );
endmodule