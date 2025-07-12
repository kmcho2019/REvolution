module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states using parameters with optimized encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;

    // Next state logic with optimized case structure
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= {in, 1'b0};  // A->B when in=1, else stay
                B: state <= in ? B : C;
                C: state <= {in, ~in};   // C->D when in=1, else A
                D: state <= in ? B : C;
            endcase
        end
    end

    // Optimized output logic - D state is 2'b11
    assign out = &state;  // AND of both state bits (only true for D)

endmodule