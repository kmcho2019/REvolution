module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic with continuous assignments
    wire next_A = (current_state[D] && (w == 1'b0));
    wire next_B = (current_state[A] && (w == 1'b1));
    wire next_C = (current_state[B] && (w == 1'b1)) || (current_state[F] && (w == 1'b1));
    wire next_D = (current_state[B] && (w == 1'b0)) 
                || (current_state[C] && (w == 1'b0)) 
                || (current_state[E] && (w == 1'b0)) 
                || (current_state[F] && (w == 1'b0));
    wire next_E = (current_state[C] && (w == 1'b1)) || (current_state[E] && (w == 1'b1));
    wire next_F = (current_state[D] && (w == 1'b1));

    always @(*) begin
        next_state = 6'b0;
        if (next_A) next_state[A] = 1'b1;
        else if (next_B) next_state[B] = 1'b1;
        else if (next_C) next_state[C] = 1'b1;
        else if (next_D) next_state[D] = 1'b1;
        else if (next_E) next_state[E] = 1'b1;
        else if (next_F) next_state[F] = 1'b1;
        else next_state = A; // default fallback to A
    end

    // Output is high in states E or F
    assign z = current_state[E] | current_state[F];

endmodule