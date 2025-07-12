module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding (2-bit)
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] current_state;

    // Next state combinational function
    function [1:0] next_state_func;
        input [1:0] state;
        input       in_sig;
        begin
            case (state)
                A: next_state_func = in_sig ? B : A;
                B: next_state_func = in_sig ? B : C;
                C: next_state_func = in_sig ? D : A;
                D: next_state_func = in_sig ? B : C;
                default: next_state_func = A;
            endcase
        end
    endfunction

    wire [1:0] next_state = next_state_func(current_state, in);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Moore output directly assigned based on current state
    assign out = (current_state == D);

endmodule