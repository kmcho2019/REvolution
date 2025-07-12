module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding as enumerated constants
    localparam A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;

    reg [1:0] state, next_state;

    // Combinational next state logic using a function for clarity
    function [1:0] get_next_state;
        input [1:0] current_state;
        input       in_sig;
        begin
            case (current_state)
                A: get_next_state = in_sig ? B : A;
                B: get_next_state = in_sig ? B : C;
                C: get_next_state = in_sig ? D : A;
                D: get_next_state = in_sig ? B : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Sequential logic block: state update and Moore output generation
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= get_next_state(state, in);
            // Output depends only on current state (Moore)
            out <= (state == D) ? 1'b1 : 1'b0;
        end
    end

endmodule