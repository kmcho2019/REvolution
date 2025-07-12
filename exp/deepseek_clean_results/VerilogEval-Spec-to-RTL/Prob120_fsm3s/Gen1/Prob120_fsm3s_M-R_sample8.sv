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

    // State registers
    reg [3:0] current_state, next_state;

    // Next state logic using continuous assignments
    assign next_state[0] = (~in & (current_state == A)) | 
                          (~in & (current_state == C));
    assign next_state[1] = (in & (current_state == A)) | 
                          (in & (current_state == B)) | 
                          (in & (current_state == D));
    assign next_state[2] = (~in & (current_state == B)) | 
                          (~in & (current_state == D));
    assign next_state[3] = (in & (current_state == C));

    // Output logic (Moore: output depends only on current state)
    assign out = (current_state == D);

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule