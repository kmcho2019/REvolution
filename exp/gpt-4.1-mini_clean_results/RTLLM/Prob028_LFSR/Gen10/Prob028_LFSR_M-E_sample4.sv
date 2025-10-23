module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    reg [3:0] state;

    always @(posedge clk) begin
        if (rst)
            state <= 4'b0001;       // Non-zero initial seed to prevent lock-up
        else begin
            // feedback = XOR of bit3 and bit2 (MSB and second MSB)
            // Shift left and input feedback into LSB
            state <= {state[2:0], state[3] ^ state[2]};
        end
    end

    // Output assigned directly from internal state
    always @(posedge clk) begin
        out <= state;
    end

endmodule