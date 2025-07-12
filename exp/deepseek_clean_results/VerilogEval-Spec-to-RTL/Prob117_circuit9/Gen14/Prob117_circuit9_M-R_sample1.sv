module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

assign next_q = a ? 3'b100 :        // Set to 4 when a is high
                (q == 3'b110) ? 3'b000 : (q + 1);  // Increment 0-6 wrap around

always @(posedge clk) begin
    q <= next_q;
end

endmodule