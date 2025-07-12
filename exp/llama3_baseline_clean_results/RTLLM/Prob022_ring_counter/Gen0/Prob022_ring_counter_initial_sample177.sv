module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] current_state;

initial begin
    current_state = 8'b0000_0001; // Initial state
end

always @(posedge clk) begin
    if(reset) begin
        current_state <= 8'b0000_0001; // Reset state
    end else begin
        current_state <= {current_state[6:0], current_state[7]}; // Shift left and wrap around
    end
end

assign out = current_state;

endmodule