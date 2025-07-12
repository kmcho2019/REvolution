module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg [1:0] state;
    localparam A = 2'b01;
    localparam B = 2'b10;

    // State transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= x ? B : A;
                B: state <= B;  // Stay in B regardless of x
                default: state <= A;
            endcase
        end
    end

    // Mealy output depends on current state and input
    assign z = (state == A) ? x : ~x;

endmodule