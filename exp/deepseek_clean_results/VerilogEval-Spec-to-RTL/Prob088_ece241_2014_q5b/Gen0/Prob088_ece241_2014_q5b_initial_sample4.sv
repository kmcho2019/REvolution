module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg [1:0] state_reg;
    localparam A = 2'b01;
    localparam B = 2'b10;

    // Next state and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= A;
        end else begin
            case (state_reg)
                A: state_reg <= x ? B : A;
                B: state_reg <= B;  // Always stay in B once we're there
                default: state_reg <= A;
            endcase
        end
    end

    // Mealy output depends on current state and input
    assign z = (state_reg == A && x) || (state_reg == B && ~x);

endmodule