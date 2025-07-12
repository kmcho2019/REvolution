module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    parameter [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // Function encapsulating next state transition logic
    function [1:0] next_state_func;
        input [1:0] current_state;
        input       in_signal;
        begin
            case (current_state)
                A: next_state_func = in_signal ? B : A;
                B: next_state_func = in_signal ? B : C;
                C: next_state_func = in_signal ? D : A;
                D: next_state_func = in_signal ? B : C;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic using the function
    always @(*) begin
        next_state = next_state_func(state, in);
    end

    // Moore output: combinational continuous assignment based on state
    assign out = (state == D);

endmodule