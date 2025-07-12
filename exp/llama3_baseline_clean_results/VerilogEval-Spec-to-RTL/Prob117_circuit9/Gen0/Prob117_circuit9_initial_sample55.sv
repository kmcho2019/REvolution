module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (~a) begin
        if (q == 3'b111) // 7 in decimal
            q <= 3'b000; // Reset to 0
        else if (q == 3'b000) // 0 in decimal
            q <= 3'b001; // Increment to 1
        else
            q <= q + 1; // Increment by 1
    end
    else begin
        // Do nothing when 'a' is high
    end
end

initial begin
    q = 3'b100; // Initialize q to 4
end

endmodule