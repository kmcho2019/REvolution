module TopModule(
    input clk, // clock input
    input d,   // data input
    output reg q  // output
);

always @(posedge clk) begin
    q <= d; // capture input data on positive clock edge
end

endmodule