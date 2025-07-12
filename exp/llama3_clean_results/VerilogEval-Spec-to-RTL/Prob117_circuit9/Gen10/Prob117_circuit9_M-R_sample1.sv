module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize 'q' to '4' at the start
initial q = 3'b100;

// Sequential logic to update 'q' at each positive clock edge
always @(posedge clk) begin
    if (a) begin
        q <= 3'b100; // Reset to 4 when 'a' is high
    end else begin
        if (q == 3'b110) begin
            q <= 3'b000; // Wrap around to 0 when q reaches 6 and 'a' is low
        end else begin
            q <= q + 1'b1; // Increment 'q' when 'a' is low
        end
    end
end

endmodule