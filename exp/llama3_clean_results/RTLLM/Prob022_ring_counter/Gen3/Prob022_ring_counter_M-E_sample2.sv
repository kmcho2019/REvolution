module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        out <= 8'b0000_0001; // Initialize the ring counter to its starting state
    end else begin
        out <= {out[6:0], out[7]}; // Perform the circular shift operation
    end
end

endmodule