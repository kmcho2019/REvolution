module TopModule(
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena && q < 10) begin
        q <= q + 1;
    end else if (slowena && q == 10) begin
        q <= 4'd0; // Reset the counter to 0 after reaching 9
    end
end

endmodule