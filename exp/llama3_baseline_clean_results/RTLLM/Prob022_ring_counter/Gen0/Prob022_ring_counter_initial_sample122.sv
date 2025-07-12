module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] current_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 8'b0000_0001; // Initialize to starting state
    end else begin
        case (current_state)
            8'b0000_0001: current_state <= 8'b0000_0010;
            8'b0000_0010: current_state <= 8'b0000_0100;
            8'b0000_0100: current_state <= 8'b0000_1000;
            8'b0000_1000: current_state <= 8'b0001_0000;
            8'b0001_0000: current_state <= 8'b0010_0000;
            8'b0010_0000: current_state <= 8'b0100_0000;
            8'b0100_0000: current_state <= 8'b1000_0000;
            8'b1000_0000: current_state <= 8'b0000_0001; // Wrap around to LSB
            default: current_state <= 8'b0000_0001; // Default to starting state
        endcase
    end
end

assign out = current_state;

endmodule