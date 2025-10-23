module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // State encoding for readability
    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    reg [2:0] state;

    // Function to determine next state based on current state and input x
    function [2:0] next_state_f;
        input [2:0] curr_state;
        input       x_in;
        begin
            case (curr_state)
                S0: next_state_f = x_in ? S1 : S0;
                S1: next_state_f = x_in ? S4 : S1;
                S2: next_state_f = x_in ? S1 : S2;
                S3: next_state_f = x_in ? S2 : S1;
                S4: next_state_f = x_in ? S4 : S3;
                default: next_state_f = S0;
            endcase
        end
    endfunction

    // Function to determine output based on current state
    function out_f;
        input [2:0] curr_state;
        begin
            out_f = (curr_state == S3) || (curr_state == S4);
        end
    endfunction

    // Sequential block: synchronous reset and state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state_f(state, x);
            z <= out_f(next_state_f(state, x)); // output aligned to next state
        end
    end

endmodule