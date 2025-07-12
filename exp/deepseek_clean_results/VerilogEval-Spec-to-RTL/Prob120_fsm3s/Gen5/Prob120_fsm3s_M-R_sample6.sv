module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    parameter [3:0] A = 4'b0001;
    parameter [3:0] B = 4'b0010;
    parameter [3:0] C = 4'b0100;
    parameter [3:0] D = 4'b1000;

    // State register (one-hot)
    reg [3:0] current_state;

    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state[A] = (current_state == A && !in) || 
                          (current_state == C && !in);
    assign next_state[B] = (current_state == A && in) || 
                          (current_state == B && in) || 
                          (current_state == D && in);
    assign next_state[C] = (current_state == B && !in) || 
                          (current_state == D && !in);
    assign next_state[D] = (current_state == C && in);

    // Output assignment
    assign out = (current_state == D);

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule