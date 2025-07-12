module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] sr;

    always @(posedge clk) begin
        sr <= !resetn ? 4'b0 : {sr[2:0], in};
    end

    assign out = sr[3];

endmodule