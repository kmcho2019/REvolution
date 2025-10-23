module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State register
    reg [3:0] current_state;

    // Next state logic using individual continuous assignments
    wire [3:0] next_state;
    assign next_state[0] = (~current_state[0] | ~in) &  // A stays if in=0
                          (~current_state[2] | ~in);    // C goes to A if in=0
    
    assign next_state[1] = (current_state[0] & in) |    // A->B if in=1
                          (current_state[1] & in) |     // B stays if in=1
                          (current_state[3] & in);      // D->B if in=1
    
    assign next_state[2] = (current_state[1] & ~in) |   // B->C if in=0
                          (current_state[3] & ~in);     // D->C if in=0
    
    assign next_state[3] = (current_state[2] & in);     // C->D if in=1

    // Output logic (Moore: output depends only on current state)
    assign out = current_state[3];

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule