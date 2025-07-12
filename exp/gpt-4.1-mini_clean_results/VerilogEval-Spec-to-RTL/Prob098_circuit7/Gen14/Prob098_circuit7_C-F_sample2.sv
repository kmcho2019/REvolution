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
    // Inline inversion of 'a' directly in DFF input connection
    DFF dff_inst (
        .clk(clk),
        .d(~a),
        .q(q)
    );
endmodule