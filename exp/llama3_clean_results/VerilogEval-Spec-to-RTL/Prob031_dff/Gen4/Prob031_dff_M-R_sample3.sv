module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    // Using a non-blocking assignment to update q
    q <= #0 d; // The #0 delay ensures the assignment is immediate in simulation
end

endmodule