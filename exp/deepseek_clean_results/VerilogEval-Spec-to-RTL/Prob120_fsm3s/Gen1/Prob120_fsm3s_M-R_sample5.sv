module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] current_state;

    // Next state logic using continuous assignments
    wire [1:0] next_state;
    assign next_state = (current_state == A) ? (in ? B : A) :
                       (current_state == B) ? (in ? B : C) :
                       (current_state == C) ? (in ? D : A) :
                       (current_state == D) ? (in ? B : C) : A;

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