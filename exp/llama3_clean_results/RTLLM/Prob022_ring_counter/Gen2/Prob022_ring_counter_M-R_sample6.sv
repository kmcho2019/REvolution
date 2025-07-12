module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state; // 3-bit state to keep track of the current position in the sequence

always @(posedge clk or posedge reset) begin
    if(reset) begin
        // Reset the state to 0, corresponding to the least significant bit (LSB)
        state <= 3'd0;
    end else begin
        // Increment the state on each rising edge of the clock signal, wrapping around to 0 after reaching 7
        state <= (state == 3'd7) ? 3'd0 : state + 3'd1;
    end
end

// Assign the output based on the current state
always @(*) begin
    case(state)
        3'd0: out = 8'b0000_0001;
        3'd1: out = 8'b0000_0010;
        3'd2: out = 8'b0000_0100;
        3'd3: out = 8'b0000_1000;
        3'd4: out = 8'b0001_0000;
        3'd5: out = 8'b0010_0000;
        3'd6: out = 8'b0100_0000;
        3'd7: out = 8'b1000_0000;
        default: out = 8'b0000_0001; // Default to the initial state if needed
    endcase
end

endmodule