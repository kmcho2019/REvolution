module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initialize q to match simulation startup behavior
);

// Update q with the inverse of a at each positive clock edge
always @(posedge clk) begin
    // This logic inverts the input 'a' and assigns it to 'q' at each positive clock edge
    q <= ~a;
end

endmodule