module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Named states for readability
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next state logic
    assign next_state = (state == A) ? (in ? B : A) :
                       (state == B) ? (in ? B : C) :
                       (state == C) ? (in ? D : A) :
                       (state == D) ? (in ? B : C) : A;

    // Sequential state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Simple output assignment
    assign out = (state == D);

endmodule