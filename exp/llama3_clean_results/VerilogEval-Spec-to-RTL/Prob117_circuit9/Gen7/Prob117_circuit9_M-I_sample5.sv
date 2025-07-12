module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    case ({a, q})
        4'b1xxx: q <= 3'd4;
        4'b0_110: q <= 3'd0;
        4'b0xxx: q <= q + 1;
    endcase
end

initial begin
    q <= 3'd4; // Initialize q at the start of simulation
end

endmodule