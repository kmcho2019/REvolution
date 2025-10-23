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

    // State registers
    reg [1:0] current_state;

    // Next state logic using continuous assignments
    wire [1:0] next_state;
    assign next_state = (current_state == A) ? (in ? B : A) :
                       (current_state == B) ? (in ? B : C) :
                       (current_state == C) ? (in ? D : A) :
                       (current_state == D) ? (in ? B : C) : A;  // Default to A (should never happen)

    // Moore output (depends only on current state)
    assign out = (current_state == D);

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule