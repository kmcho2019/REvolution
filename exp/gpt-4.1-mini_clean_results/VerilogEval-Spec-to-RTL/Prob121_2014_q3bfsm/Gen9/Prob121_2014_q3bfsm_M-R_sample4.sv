module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding using localparams for readability and maintainability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state;

    // Next state logic implemented as a function for modularity
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input       x_in;
        begin
            case (curr_state)
                S0: next_state_func = x_in ? S1 : S0;
                S1: next_state_func = x_in ? S4 : S1;
                S2: next_state_func = x_in ? S1 : S2;
                S3: next_state_func = x_in ? S2 : S1;
                S4: next_state_func = x_in ? S4 : S3;
                default: next_state_func = S0;
            endcase
        end
    endfunction

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_func(state, x);
    end

    // Output logic: output 'z' is high for states S3 and S4, implemented as continuous assign
    assign z = (state == S3) || (state == S4);

endmodule