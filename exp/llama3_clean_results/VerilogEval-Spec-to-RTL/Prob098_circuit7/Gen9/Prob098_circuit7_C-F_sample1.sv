module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Explicit initial state to match simulation
);

always @(posedge clk) begin
    if (~a) begin
        q <= 1'b1; // q remains high when a is low
    end else if (q == 1'b1) begin
        q <= 1'b0; // q goes low when a is high and q is high
    end
end

endmodule