module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // Next state logic (combinational)
    assign next_state = 
        (current_state == A) ? (in ? B : A) :
        (current_state == B) ? (in ? B : C) :
        (current_state == C) ? (in ? D : A) :
        (current_state == D) ? (in ? B : C) :
        A;  // default case

    // State update (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (combinational)
    assign out = (current_state == D);

endmodule