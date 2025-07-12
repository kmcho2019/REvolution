module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Asynchronous reset: set the counter to its initial state
        out <= 8'b0000_0001;
    end else begin
        // Cyclic state transition: shift the current state to the left and wrap around
        out <= {out[6:0], out[7]};
    end
end

endmodule