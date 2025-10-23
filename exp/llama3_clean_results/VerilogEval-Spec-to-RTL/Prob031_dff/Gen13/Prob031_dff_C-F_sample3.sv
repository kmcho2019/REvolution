module TopModule(
    input clk,
    input d,
    output reg q
);

// Utilize a non-blocking assignment to update the output reg
always @(posedge clk) begin
    // Update the output based on the input d
    q <= d;
end

endmodule