module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] current_state, next_state;

    // Next state logic combinational block
    always @(*) begin
        // Default no change
        next_state = 4'b0000;
        case (1'b1)
            current_state[A]: next_state = (in == 1'b0) ? A : B;
            current_state[B]: next_state = (in == 1'b0) ? C : B;
            current_state[C]: next_state = (in == 1'b0) ? A : D;
            current_state[D]: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Safe default to A
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Moore output logic: output = 1 when state D, else 0
    always @(*) begin
        out = current_state[D];
    end

endmodule