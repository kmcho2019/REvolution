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
    wire not_a;
    assign not_a = ~a;

    DFF dff_inst (
        .clk(clk),
        .d(not_a),
        .q(q)
    );
endmodule