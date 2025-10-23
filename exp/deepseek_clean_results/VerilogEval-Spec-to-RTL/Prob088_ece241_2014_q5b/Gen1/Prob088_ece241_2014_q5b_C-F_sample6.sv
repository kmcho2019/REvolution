module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Optimized one-hot state encoding
    reg [1:0] state;
    localparam A = 2'b01;
    localparam B = 2'b10;

    // Combined state transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= x ? B : A;
                B: state <= B;
                default: state <= A;
            endcase
        end
    end

    // Optimized Mealy output - XOR of state[1] and x
    assign z = state[1] ^ x;

endmodule