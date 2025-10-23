module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= #0 0; // Explicitly specifying the reset condition with a delay of 0
    end else begin
        q <= #0 d; // Using non-blocking assignment for consistency and potential improvement
    end
end

endmodule