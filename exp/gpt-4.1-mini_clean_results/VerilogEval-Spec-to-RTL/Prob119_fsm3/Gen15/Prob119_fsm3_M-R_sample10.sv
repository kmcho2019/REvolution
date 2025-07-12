module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    parameter A = 2'b00,
              B = 2'b01,
              C = 2'b10,
              D = 2'b11;

    reg [1:0] state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic as function
    function [1:0] next_state_func;
        input [1:0] curr_state;
        input in_sig;
        begin
            case(curr_state)
                A: next_state_func = in_sig ? B : A;
                B: next_state_func = in_sig ? B : C;
                C: next_state_func = in_sig ? D : A;
                D: next_state_func = in_sig ? B : C;
                default: next_state_func = A;
            endcase
        end
    endfunction

    wire [1:0] next_state;
    assign next_state = next_state_func(state, in);

    // Output combinational logic (Moore output)
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule