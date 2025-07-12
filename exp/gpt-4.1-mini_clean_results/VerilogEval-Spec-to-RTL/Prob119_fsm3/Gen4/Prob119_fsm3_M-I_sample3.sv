module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic (one-hot encoding)
    always @(*) begin
        case (1'b1) // priority encoding style for one-hot state
            state[0]: next_state = in ? B : A; // A state
            state[1]: next_state = in ? B : C; // B state
            state[2]: next_state = in ? D : A; // C state
            state[3]: next_state = in ? B : C; // D state
            default:  next_state = A;
        endcase
    end

    // Output logic: out is '1' only in state D (one-hot)
    assign out = state[3];

endmodule