module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the counter
initial q = 4;

// Update the counter at every positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        if (q == 6) begin
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule