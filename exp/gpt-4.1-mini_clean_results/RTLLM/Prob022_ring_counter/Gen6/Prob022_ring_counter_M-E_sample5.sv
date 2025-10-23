module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    reg [2:0] state; // 3-bit state to count 0..7

    // State transition: increment modulo 8
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000; // Initialize to 0
        end else begin
            if (state == 3'b111)
                state <= 3'b000;
            else
                state <= state + 1'b1;
        end
    end

    // Output decoding: one-hot vector with only bit 'state' set
    always @(*) begin
        out = 8'b0;      // Clear output
        out[state] = 1'b1; // Set only the bit indicated by state
    end

endmodule