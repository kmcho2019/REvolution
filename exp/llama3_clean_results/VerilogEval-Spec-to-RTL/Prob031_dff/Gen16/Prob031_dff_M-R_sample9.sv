module TopModule(
    input clk,
    input d,
    output reg q
);

// The always block is triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment to ensure the new value is assigned at the next clock edge
    q <= d;
end

endmodule