module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding as localparams
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Function to compute next state
    function [1:0] next_state_fn;
        input [1:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                A: next_state_fn = in_bit ? B : A;
                B: next_state_fn = in_bit ? B : C;
                C: next_state_fn = in_bit ? D : A;
                D: next_state_fn = in_bit ? B : C;
                default: next_state_fn = A;
            endcase
        end
    endfunction

    // State and output register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state_fn(state, in);
            // Output depends only on state (Moore)
            out <= (state == D) ? 1'b1 : 1'b0;
        end
    end

endmodule