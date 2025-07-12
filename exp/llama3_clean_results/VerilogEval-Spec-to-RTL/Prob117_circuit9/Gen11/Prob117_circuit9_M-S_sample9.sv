module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk)
begin
    if (a) begin
        q <= 4; // Reset q to 4 when a is high
    end else begin
        if (q == 7) begin
            q <= 0; // Reset q to 0 when it reaches 7 and a is low
        end else begin
            q <= q + 1; // Increment q when a is low
        end
    end
end

endmodule