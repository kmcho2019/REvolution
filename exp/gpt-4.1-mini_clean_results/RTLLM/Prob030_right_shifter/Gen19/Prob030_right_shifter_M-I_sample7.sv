module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

// Initial block for simulation only; synthesis tools typically ignore initial blocks
initial q = 8'b0;

always @(posedge clk) begin
    // On each rising clock edge, shift right and insert 'd' at MSB
    q <= {d, q[7:1]};
end

endmodule