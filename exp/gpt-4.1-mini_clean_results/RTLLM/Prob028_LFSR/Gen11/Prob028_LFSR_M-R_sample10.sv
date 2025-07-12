module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] state;
    wire feedback;
    wire [3:0] next_state;

    // Calculate feedback as inverted XOR of out[3] and out[2]
    assign feedback = ~(state[3] ^ state[2]);

    // Next state shifts left by one bit and inserts feedback at LSB
    assign next_state = {state[2:0], feedback};

    // State register update on clock edge with synchronous reset to zero
    always @(posedge clk) begin
        if (rst)
            state <= 4'b0000;
        else
            state <= next_state;
    end

    // Output current state
    assign out = state;

endmodule