module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    reg  [3:0] next_state;

    // Feedback calculation: inversion of XOR of bits 3 and 2
    assign feedback = ~(out[3] ^ out[2]);

    // Next state logic (combinational)
    always @(*) begin
        next_state = {out[2:0], feedback}; // shift left, insert feedback at LSB
    end

    // Sequential update of the LFSR state
    always @(posedge clk) begin
        if (rst) 
            out <= 4'b1001; // Non-zero seed on reset
        else 
            out <= next_state;
    end

endmodule