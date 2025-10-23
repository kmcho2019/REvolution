module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 8'b00000001; // Initialize with LSB set
        else begin
            if (out[7] == 1'b1)
                out <= {7'b0, 1'b1}; // Wrap around to LSB
            else
                out <= out << 1; // Shift left
        end
    end

endmodule