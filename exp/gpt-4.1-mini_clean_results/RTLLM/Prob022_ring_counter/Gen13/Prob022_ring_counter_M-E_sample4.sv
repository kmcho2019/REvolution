module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001; // Initialize with LSB set
        end else begin
            // Circular right rotate by 1: MSB becomes LSB, others shift right by 1
            out <= {out[0], out[7:1]};
        end
    end

endmodule