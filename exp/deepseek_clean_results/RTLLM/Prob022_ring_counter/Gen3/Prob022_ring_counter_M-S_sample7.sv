module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        out <= 8'b00000001;  // Initialize to LSB set
    else
        out <= {out[6:0], out[7]};  // Shift left with wrap-around
end

endmodule