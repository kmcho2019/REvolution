module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        out <= 8'b00000001;
    else begin
        // Shift left by one; if MSB is currently set, wrap to LSB
        if (out[7] == 1'b1)
            out <= 8'b00000001;
        else
            out <= out << 1;
    end
end

endmodule