module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot state encoding (4 states)
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic with one-hot encoding
    always @(*) begin
        // Default to prevent latches
        next_state = A;
        case (1'b1)
            state[A]: next_state = ~in ? A : B;
            state[B]: next_state = ~in ? C : B;
            state[C]: next_state = ~in ? A : D;
            state[D]: next_state = ~in ? C : B;
            default:  next_state = A;
        endcase
    end

    // Moore output logic registered to reduce glitches and power
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= state[D];
    end

endmodule