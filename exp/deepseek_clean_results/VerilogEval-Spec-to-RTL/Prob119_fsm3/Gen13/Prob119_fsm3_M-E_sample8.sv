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

    // Parallel next state predictions
    wire [1:0] next_A = in ? B : A;
    wire [1:0] next_B = in ? B : C;
    wire [1:0] next_C = in ? D : A;
    wire [1:0] next_D = in ? B : C;

    // Next state selection mux
    reg [1:0] next_state;
    always @(*) begin
        case (state)
            A: next_state = next_A;
            B: next_state = next_B;
            C: next_state = next_C;
            D: next_state = next_D;
            default: next_state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule