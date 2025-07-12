module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (1'b1)
            state[0]: // A active
                next_state = in ? B : A;
            state[1]: // B active
                next_state = in ? B : C;
            state[2]: // C active
                next_state = in ? D : A;
            state[3]: // D active
                next_state = in ? B : C;
            default:
                next_state = A;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is 1 only in state D (one-hot D = 4'b1000)
    assign out = state[3];

endmodule