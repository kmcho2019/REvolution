module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // Named state encoding for clarity
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next state logic: next_state = state XOR NOT(in)
    wire next_state = state ^ ~in;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output registered to reduce glitches
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= B;  // Output equals state B on reset
        else
            out <= state;
    end

endmodule