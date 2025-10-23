module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [7:0] state;

    // Update the internal state on clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b00000001;
        end else begin
            if (state[7] == 1'b1)
                state <= 8'b00000001; // wrap around when MSB was set
            else
                state <= state << 1;  // shift left by 1
        end
    end

    // Output is just the current state
    assign out = state;

endmodule