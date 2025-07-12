module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;

    // Next state logic using continuous assignment
    wire [1:0] next_state = 
        (state == A) ? (in ? B : A) :
        (state == B) ? (in ? B : C) :
        (state == C) ? (in ? D : A) :
        (state == D) ? (in ? B : C) : A;

    // Sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule