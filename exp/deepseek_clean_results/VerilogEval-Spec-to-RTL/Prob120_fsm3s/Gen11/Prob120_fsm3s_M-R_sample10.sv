module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding parameters
    parameter [3:0] A = 4'b0001,
                    B = 4'b0010,
                    C = 4'b0100,
                    D = 4'b1000;

    // State registers
    reg [3:0] current_state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (1'b1) // Synthesis will optimize this case statement
            current_state[A]: next_state = in ? B : A;
            current_state[B]: next_state = in ? B : C;
            current_state[C]: next_state = in ? D : A;
            current_state[D]: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Moore output (depends only on current state)
    assign out = current_state[D];

endmodule