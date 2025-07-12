module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding using parameters
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
            state <= next_state(state, in);
    end

    // Next state combinational function
    function [1:0] next_state;
        input [1:0] curr_state;
        input in_bit;
        begin
            case(curr_state)
                A: next_state = in_bit ? B : A;
                B: next_state = in_bit ? B : C;
                C: next_state = in_bit ? D : A;
                D: next_state = in_bit ? B : C;
                default: next_state = A;
            endcase
        end
    endfunction

    // Output logic combinational function
    function out_fn;
        input [1:0] curr_state;
        begin
            out_fn = (curr_state == D) ? 1'b1 : 1'b0;
        end
    endfunction

    // Assign output directly from function of current state
    assign out = out_fn(state);

endmodule