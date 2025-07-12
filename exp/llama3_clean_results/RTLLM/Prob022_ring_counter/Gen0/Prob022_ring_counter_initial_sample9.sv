module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    // Internal state register
    reg [7:0] state;

    // Combinational logic to generate next state
    always @(*) begin
        if (reset) begin
            // Reset to initial state
            state = 8'b0000_0001;
        end else begin
            // Shift current state to the left
            state = {state[6:0], state[7]};
        end
    end

    // Update output on each clock pulse
    always @(posedge clk) begin
        out <= state;
    end

endmodule