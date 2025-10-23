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
    // Directly feed inverted input 'a' to DFF input without extra wires
    DFF dff_inst (
        .clk(clk),
        .d(~a),
        .q(q)
    );
endmodule