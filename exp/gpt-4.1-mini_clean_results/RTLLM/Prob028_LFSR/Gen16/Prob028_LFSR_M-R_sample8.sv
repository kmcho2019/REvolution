module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] state;
    wire feedback;

    // Feedback is the inverted XOR of bits 3 and 2
    assign feedback = ~(state[3] ^ state[2]);

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= 4'b0000;
        else
            state <= {state[2:0], feedback};
    end

    assign out = state;

endmodule