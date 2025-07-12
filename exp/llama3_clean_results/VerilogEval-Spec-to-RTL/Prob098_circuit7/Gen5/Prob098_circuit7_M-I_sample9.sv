module TopModule(
    input clk,
    input a,
    output reg q
);

// At each positive clock edge, set q to the inverse of a
always @(posedge clk) begin
    q <= ~a; // This implements the required sequential logic
end

endmodule