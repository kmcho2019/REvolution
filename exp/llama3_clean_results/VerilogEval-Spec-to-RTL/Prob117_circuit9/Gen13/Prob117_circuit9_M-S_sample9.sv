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
        q <= (q == 3'b110)? 3'b000 : q + 1'b1; // Wrap around or increment 'q' when 'a' is low
    end
end

endmodule