module ring_counter(
    input           clk,
    input           reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize the counter to its starting state
            out <= 8'b0000_0001;
        end else begin
            // Shift the current state to the next bit
            out <= {out[6:0], out[7]};
        end
    end

endmodule