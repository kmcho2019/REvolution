module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] state;

// Next state logic as function
function [1:0] next_state_func(input [1:0] curr_state, input in_signal);
    begin
        case(curr_state)
            A: next_state_func = (in_signal) ? B : A;
            B: next_state_func = (in_signal) ? B : C;
            C: next_state_func = (in_signal) ? D : A;
            D: next_state_func = (in_signal) ? B : C;
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

// Output logic (Moore) as continuous assignment
assign out = (state == D);

endmodule