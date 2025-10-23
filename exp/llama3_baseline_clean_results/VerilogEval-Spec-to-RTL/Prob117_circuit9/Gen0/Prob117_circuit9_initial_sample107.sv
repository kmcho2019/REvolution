module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1) begin
        q <= 4;  // Reset q to 4 when a is 1
    end else begin
        if (q == 7) begin  // If q is 7 (111 in binary), reset it to 0
            q <= 0;
        end else begin
            q <= q + 1;  // Increment q when a is 0
        end
    end
end

endmodule