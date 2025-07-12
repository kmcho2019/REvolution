module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define one-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State register (one-hot)
    reg [3:0] current_state;

    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state[A] = (~reset) & ((current_state[A] & ~in) | 
                          (current_state[C] & ~in));
    assign next_state[B] = (~reset) & ((current_state[A] & in) | 
                          (current_state[B] & in) | 
                          (current_state[D] & in));
    assign next_state[C] = (~reset) & ((current_state[B] & ~in) | 
                          (current_state[C] & ~in) | 
                          (current_state[D] & ~in));
    assign next_state[D] = (~reset) & (current_state[C] & in);

    // Output logic (Moore: output depends only on current state)
    assign out = current_state[D];

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule