module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic broken down by current state signals
    wire ns_A = (state == A) & (w == 1'b1);
    wire ns_B_1 = (state == B) & (w == 1'b1);
    wire ns_B_0 = (state == B) & (w == 1'b0);
    wire ns_C_1 = (state == C) & (w == 1'b1);
    wire ns_C_0 = (state == C) & (w == 1'b0);
    wire ns_D_1 = (state == D) & (w == 1'b1);
    wire ns_D_0 = (state == D) & (w == 1'b0);
    wire ns_E_1 = (state == E) & (w == 1'b1);
    wire ns_E_0 = (state == E) & (w == 1'b0);
    wire ns_F_1 = (state == F) & (w == 1'b1);
    wire ns_F_0 = (state == F) & (w == 1'b0);

    always @(*) begin
        // Default next state is A to avoid latches
        next_state = A;

        if (ns_A)        next_state = B;
        else if (state == A && !w) next_state = A;

        else if (ns_B_1) next_state = C;
        else if (ns_B_0) next_state = D;

        else if (ns_C_1) next_state = E;
        else if (ns_C_0) next_state = D;

        else if (ns_D_1) next_state = F;
        else if (ns_D_0) next_state = A;

        else if (ns_E_1) next_state = E;
        else if (ns_E_0) next_state = D;

        else if (ns_F_1) next_state = C;
        else if (ns_F_0) next_state = D;
    end

    // Output logic using always_comb style
    always @(*) begin
        // z = 1 for states E and F, else 0
        case (state)
            E, F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule