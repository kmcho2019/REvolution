module DFF_Invert (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // Invert 'a' inside the sequential logic
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    DFF_Invert dff_inv_inst (
        .clk(clk),
        .a(a),
        .q(q)
    );
endmodule