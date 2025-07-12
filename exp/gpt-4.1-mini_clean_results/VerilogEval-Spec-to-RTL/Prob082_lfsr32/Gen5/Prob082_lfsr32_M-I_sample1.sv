module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];

    wire [31:0] next_state;

    // Next state bits:
    // For taps at bits 31, 21, and 1: next_bit = q[bit-1] ^ feedback
    // For others: next_bit = q[bit-1]
    // bit 0 is special: next_bit0 = q[31] ^ feedback (since shift right)

    assign next_state[0]  = q[31] ^ feedback;
    assign next_state[31] = q[30] ^ feedback;
    assign next_state[21] = q[20] ^ feedback;
    assign next_state[1]  = q[0]  ^ feedback;

    // Bits without taps just shift right
    genvar i;
    generate
        for (i = 2; i < 31; i = i + 1) begin : gen_no_tap
            if (i != 21) begin
                assign next_state[i] = q[i-1];
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_state;
        end
    end

endmodule