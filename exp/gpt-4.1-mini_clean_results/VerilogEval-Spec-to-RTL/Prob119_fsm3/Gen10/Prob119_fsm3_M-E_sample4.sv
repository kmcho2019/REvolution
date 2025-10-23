module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding for 4 states
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] current_state, next_state;

    // Asynchronous reset and state register update on posedge clk
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state based on one-hot encoding
    always @(*) begin
        case (1'b1)
            current_state[0]: // A
                next_state = (in == 1'b0) ? A : B;
            current_state[1]: // B
                next_state = (in == 1'b0) ? C : B;
            current_state[2]: // C
                next_state = (in == 1'b0) ? A : D;
            current_state[3]: // D
                next_state = (in == 1'b0) ? C : B;
            default: // safety fallback
                next_state = A;
        endcase
    end

    // Moore output depends only on being in state D
    assign out = current_state[3];

endmodule