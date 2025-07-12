module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Function for next state calculation
    function [1:0] next_state_func;
        input [1:0] current_state;
        input       in_signal;
        begin
            case (current_state)
                A: next_state_func = (in_signal == 1'b0) ? A : B;
                B: next_state_func = (in_signal == 1'b0) ? C : B;
                C: next_state_func = (in_signal == 1'b0) ? A : D;
                D: next_state_func = (in_signal == 1'b0) ? C : B;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state_func(state, in);
    end

    // Moore output: combinational continuous assignment based on state
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule