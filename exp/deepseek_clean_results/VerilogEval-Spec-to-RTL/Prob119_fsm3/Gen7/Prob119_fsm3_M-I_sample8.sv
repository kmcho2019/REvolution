module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State registers
    reg [3:0] current_state, next_state;

    // Combinational next state logic (optimized for one-hot)
    always @(*) begin
        next_state = 4'b0;
        case (1'b1) // synthesis parallel_case
            current_state[A]: next_state = in ? B : A;
            current_state[B]: next_state = in ? B : C;
            current_state[C]: next_state = in ? D : A;
            current_state[D]: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) current_state <= A;
        else current_state <= next_state;
    end

    // Output logic - directly use state D bit
    assign out = current_state[D];

endmodule