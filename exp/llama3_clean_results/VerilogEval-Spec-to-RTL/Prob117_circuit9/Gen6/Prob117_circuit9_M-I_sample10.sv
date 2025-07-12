module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Ensure correct bit width for initialization
    end else if (q == 3'd6) begin
        q <= 3'd0;
    end else begin
        q <= q + 1;
    end
end

initial begin
    q <= 3'd4; // Initialize q at the start of simulation
end

endmodule