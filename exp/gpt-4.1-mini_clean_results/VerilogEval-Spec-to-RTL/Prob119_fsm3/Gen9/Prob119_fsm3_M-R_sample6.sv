module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// State encoding
localparam A = 2'd0,
           B = 2'd1,
           C = 2'd2,
           D = 2'd3;

reg [1:0] state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state_function(state, in);
end

// Combinational function to compute next state
function [1:0] next_state_function(input [1:0] curr_state, input in_bit);
    begin
        case (curr_state)
            A: next_state_function = (in_bit) ? B : A;
            B: next_state_function = (in_bit) ? B : C;
            C: next_state_function = (in_bit) ? D : A;
            D: next_state_function = (in_bit) ? B : C;
            default: next_state_function = A;
        endcase
    end
endfunction

// Combinational function for Moore output
function out_function(input [1:0] curr_state);
    begin
        out_function = (curr_state == D) ? 1'b1 : 1'b0;
    end
endfunction

assign out = out_function(state);

endmodule