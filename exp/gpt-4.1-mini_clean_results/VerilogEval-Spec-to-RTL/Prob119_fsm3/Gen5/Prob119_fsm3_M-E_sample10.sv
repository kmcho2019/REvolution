module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding: only one bit high at a time
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        // Default no states active
        next_state = 4'b0000;

        case (1'b1) // Priority encoding for current state
            state[0]: // A active
                if (in) next_state = B; else next_state = A;
            state[1]: // B active
                if (in) next_state = B; else next_state = C;
            state[2]: // C active
                if (in) next_state = D; else next_state = A;
            state[3]: // D active
                if (in) next_state = B; else next_state = C;
            default:
                next_state = A; // Safety fallback
        endcase
    end

    // Output logic (Moore) combinational: high only in state D
    assign out = state[3];

endmodule