module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b1) begin
        // If this is the first clock edge when 'a' goes high, set q to 4
        // Otherwise, keep the current value of q
        if (q == 3'b000) begin
            q <= 3'b100;
        end
    end else begin
        // If 'a' is 0, increment q
        q <= q + 1'b1;
        // Handle wraparound
        if (q == 3'b111) begin
            q <= 3'b000;
        end
    end
end

endmodule