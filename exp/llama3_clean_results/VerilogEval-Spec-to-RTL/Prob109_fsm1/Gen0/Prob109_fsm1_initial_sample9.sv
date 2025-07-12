module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    reg [0:0] state;
    parameter B = 1'b1;
    parameter A = 1'b0;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= (in) ? B : A;
                A: state <= (in) ? A : B;
                default: state <= B;
            endcase
        end
    end

    // Output logic
    assign out = state;

endmodule