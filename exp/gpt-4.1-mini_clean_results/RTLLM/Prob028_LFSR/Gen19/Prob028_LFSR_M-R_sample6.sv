module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;
    reg [3:0] lfsr_next;

    // Feedback function: inverted XOR of bits 3 and 2
    function automatic logic feedback_bit(input logic [3:0] state);
        feedback_bit = ~(state[3] ^ state[2]);
    endfunction

    // Calculate next state combinationally
    always @(*) begin
        lfsr_next = {lfsr_reg[2:0], feedback_bit(lfsr_reg)};
    end

    // Sequential logic: update register on clock edge
    always @(posedge clk) begin
        if (rst)
            lfsr_reg <= 4'b0001;  // non-zero seed
        else
            lfsr_reg <= lfsr_next;
    end

    assign out = lfsr_reg;

endmodule