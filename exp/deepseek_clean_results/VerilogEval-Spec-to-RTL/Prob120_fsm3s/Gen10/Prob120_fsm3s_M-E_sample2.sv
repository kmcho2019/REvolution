module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Shift register implementation (4-bit circular)
    // State mapping: A=1000, B=0100, C=0010, D=0001
    reg [3:0] state;

    // Next state logic - shift right (in=0) or left (in=1)
    wire [3:0] next_state;
    assign next_state = in ? {state[2:0], state[3]} :  // Left shift (circular)
                               {state[0], state[3:1]};  // Right shift (circular)

    // Output is MSB of state register (state[3])
    assign out = state[0];  // Since D=0001 has LSB set

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 4'b1000;  // Reset to state A (1000)
        else
            state <= next_state;
    end

endmodule