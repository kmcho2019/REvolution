module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state;

    // Parallel next state computation
    wire [1:0] next_A = in ? B : A;
    wire [1:0] next_B = in ? B : C;
    wire [1:0] next_C = in ? D : A;
    wire [1:0] next_D = in ? B : C;

    // Next state selection mux
    wire [1:0] next_state;
    assign next_state = (state == A) ? next_A :
                       (state == B) ? next_B :
                       (state == C) ? next_C :
                       next_D;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule