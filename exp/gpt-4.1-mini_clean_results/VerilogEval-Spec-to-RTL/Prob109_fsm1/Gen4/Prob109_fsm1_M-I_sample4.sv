module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // State and output update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
            out <= B;    // output corresponds to state B = 1
        end else begin
            state <= next_state;
            out <= next_state; // output is function of current state (Moore)
        end
    end

endmodule