module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0]; // LSB feedback bit

    wire [4:0] next_state;

    // Compute next state combinationally:
    // Shift right by one bit,
    // XOR taps at bits 5 (q[4]) and 3 (q[2]) with feedback bit
    assign next_state[0] = q[1];
    assign next_state[1] = q[2];
    assign next_state[2] = q[3] ^ feedback; // tap at bit 3
    assign next_state[3] = q[4];
    assign next_state[4] = feedback;        // tap at bit 5

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            q <= next_state;
        end
    end

endmodule