module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding parameters
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    assign next_state = (current_state == A) ? (in ? B : A) :
                       (current_state == B) ? (in ? B : C) :
                       (current_state == C) ? (in ? D : A) :
                       (current_state == D) ? (in ? B : C) : A;

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (high only in state D)
    assign out = (current_state == D);

endmodule