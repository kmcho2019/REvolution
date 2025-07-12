module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with named parameters
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] state;

    // Next state logic using ternary operators
    wire [1:0] next_state = 
        (state == A) ? (in ? B : A) :
        (state == B) ? (in ? B : C) :
        (state == C) ? (in ? D : A) :
        (state == D) ? (in ? B : C) : A;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;  // Reset to state A
        else
            state <= next_state;
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == D);

endmodule