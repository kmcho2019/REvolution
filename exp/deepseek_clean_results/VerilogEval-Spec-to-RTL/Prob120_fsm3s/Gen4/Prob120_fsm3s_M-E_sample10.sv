module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding (A=0001, B=0010, C=0100, D=1000)
    reg [3:0] state;

    // Next state parallel load value
    wire [3:0] next_state;
    assign next_state = (state == 4'b0001) ? (in ? 4'b0010 : 4'b0001) :  // A -> B or A
                       (state == 4'b0010) ? (in ? 4'b0010 : 4'b0100) :  // B -> B or C
                       (state == 4'b0100) ? (in ? 4'b1000 : 4'b0001) :  // C -> D or A
                       (state == 4'b1000) ? (in ? 4'b0010 : 4'b0100) :  // D -> B or C
                       4'b0001;  // Default to A

    // Output is just the D state bit (MSB)
    assign out = state[3];

    // Shift register with parallel load functionality
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001;  // Reset to state A
        else
            state <= next_state;
    end

endmodule