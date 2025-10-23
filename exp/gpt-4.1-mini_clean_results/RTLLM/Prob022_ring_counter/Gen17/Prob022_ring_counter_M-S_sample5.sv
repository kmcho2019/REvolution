module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        out <= 8'b00000001;
    else
        out <= (out == 8'b10000000) ? 8'b00000001 : (out << 1);
end

endmodule