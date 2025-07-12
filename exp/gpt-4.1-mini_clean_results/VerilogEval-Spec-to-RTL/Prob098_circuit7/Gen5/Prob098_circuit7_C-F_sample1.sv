module DFF_invert (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= ~d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    DFF_invert dff_inst (
        .clk(clk),
        .d(a),
        .q(q)
    );
endmodule