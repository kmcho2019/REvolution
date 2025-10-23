module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] sr;

    always @(posedge clk)
        sr <= !resetn ? 4'b0 : {sr[2:0], in};

    assign out = sr[3];

endmodule