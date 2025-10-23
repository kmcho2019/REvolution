module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot encoding of states
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (1'b1) // priority encoder style for one-hot state detection
            state[0]: begin // A
                next_state = (in == 1'b0) ? A : B;
            end
            state[1]: begin // B
                next_state = (in == 1'b0) ? C : B;
            end
            state[2]: begin // C
                next_state = (in == 1'b0) ? A : D;
            end
            state[3]: begin // D
                next_state = (in == 1'b0) ? C : B;
            end
            default: next_state = A; // safety fallback
        endcase
    end

    // State flip-flops with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // reset to state A (one-hot)
        else
            state <= next_state;
    end

    // Moore output logic: output high only in state D
    always @(*) begin
        out = state[3]; // output is 1 only in D, else 0
    end

endmodule