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

    // State register
    reg [3:0] current_state;

    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state = (current_state == A) ? (in ? B : A) :
                       (current_state == B) ? (in ? B : C) :
                       (current_state == C) ? (in ? D : A) :
                       (current_state == D) ? (in ? B : C) :
                       4'b0000; // Should never reach here

    // Output is just the MSB of one-hot encoded state (D=1000)
    assign out = current_state[3];

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule