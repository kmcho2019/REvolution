module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding for 6 states
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        next_state = 6'b0; // default no state

        if (state == A) begin
            if (w)
                next_state = A;
            else
                next_state = B;
        end else if (state == B) begin
            if (w)
                next_state = D;
            else
                next_state = C;
        end else if (state == C) begin
            if (w)
                next_state = D;
            else
                next_state = E;
        end else if (state == D) begin
            if (w)
                next_state = A;
            else
                next_state = F;
        end else if (state == E) begin
            if (w)
                next_state = D;
            else
                next_state = E;
        end else if (state == F) begin
            if (w)
                next_state = D;
            else
                next_state = C;
        end else begin
            next_state = A; // Default safe state
        end
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z combinational: z=1 for states E or F
    always @(*) begin
        z = state[5] | state[4]; // state[5]=F, state[4]=E
    end

endmodule