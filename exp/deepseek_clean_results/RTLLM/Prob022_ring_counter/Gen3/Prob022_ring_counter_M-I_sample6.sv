module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize to LSB set
    end
    else begin
        if (out == 8'b10000000)
            out <= 8'b00000001;  // Wrap around from MSB to LSB
        else
            out <= out << 1;     // Shift left normally
    end
end

endmodule