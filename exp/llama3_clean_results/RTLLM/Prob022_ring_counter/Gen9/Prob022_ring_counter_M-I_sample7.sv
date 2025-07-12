module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state; // Internal 3-bit state to track the position

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset the state to 0
        out <= 8'b0000_0001; // Initialize out with the LSB set to 1
    end else begin
        state <= (state + 1) % 8; // Increment the state and wrap around
        case (state)
            0: out <= 8'b0000_0001;
            1: out <= 8'b0000_0010;
            2: out <= 8'b0000_0100;
            3: out <= 8'b0000_1000;
            4: out <= 8'b0001_0000;
            5: out <= 8'b0010_0000;
            6: out <= 8'b0100_0000;
            7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule