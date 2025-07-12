module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize q to 0 at the start
initial q = 1'b0;

// Use always block with positive edge sensitivity
always @(posedge clk) begin
    q <= d; // Note the non-blocking assignment here for sequential behavior
end

endmodule