module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// Parameter for initial state
parameter INIT_STATE = 8'b00000001;

// Single always block for sequential logic
always @(posedge clk) begin
    if (reset) begin
        out <= INIT_STATE;
    end else begin
        // Circular shift left with wrap-around
        out <= {out[6:0], out[7]};
    end
end

endmodule