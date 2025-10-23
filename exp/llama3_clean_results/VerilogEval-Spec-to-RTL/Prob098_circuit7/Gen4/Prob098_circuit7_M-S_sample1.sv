module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initialize q to match simulation startup behavior
);

// Update q with the inverse of a at each positive clock edge
always @(posedge clk) begin
    q <= ~a;
end

endmodule