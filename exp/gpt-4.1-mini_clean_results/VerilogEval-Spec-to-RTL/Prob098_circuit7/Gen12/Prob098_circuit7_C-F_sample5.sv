module DFF #(parameter INVERT_D = 1'b0) (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (INVERT_D)
            q <= ~d;
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Instantiate DFF that captures inverted input internally by enabling INVERT_D parameter
    DFF #(.INVERT_D(1'b1)) dff_inst (
        .clk(clk),
        .d(a),
        .q(q)
    );
endmodule