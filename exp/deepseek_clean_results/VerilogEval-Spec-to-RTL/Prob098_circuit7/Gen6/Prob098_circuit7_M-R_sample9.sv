module TopModule (
    input clk,
    input a,
    output q
);

// Explicit D flip-flop with inverted input
DFF dff_inst (
    .clk(clk),
    .d(~a),
    .q(q)
);

endmodule

// D flip-flop module definition
module DFF (
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule