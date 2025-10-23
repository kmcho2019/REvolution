module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    reg state;
    parameter B = 1'b1;
    parameter A = 1'b0;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case ({state, in})
                {B, 0}: state <= A;
                {B, 1}: state <= B;
                {A, 0}: state <= B;
                {A, 1}: state <= A;
                default: state <= B;
            endcase
        end
    end

    // Output logic
    assign out = state;

endmodule