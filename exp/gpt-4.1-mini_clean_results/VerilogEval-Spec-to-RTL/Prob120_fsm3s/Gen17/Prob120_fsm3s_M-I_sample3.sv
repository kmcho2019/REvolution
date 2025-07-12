module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (1'b1) // one-hot encoded current state
            state[0]: next_state = in ? B : A; // A
            state[1]: next_state = in ? B : C; // B
            state[2]: next_state = in ? D : A; // C
            state[3]: next_state = in ? B : C; // D
            default:  next_state = A;
        endcase
    end

    // Moore output depends only on current state (D)
    assign out = state[3];

endmodule