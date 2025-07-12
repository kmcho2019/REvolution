module TopModule(
    input clk,
    input a,
    output reg q = 1 // Initial state of q
);

always @(posedge clk) begin
    q <= ~a; // Update q with the inverse of a at every positive clock edge
end

endmodule