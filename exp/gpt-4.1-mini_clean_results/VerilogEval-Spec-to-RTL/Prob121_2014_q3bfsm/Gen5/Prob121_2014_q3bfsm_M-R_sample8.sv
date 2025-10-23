module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // Function to determine next state based on current state and x
    function [2:0] get_next_state;
        input [2:0] cur_state;
        input       in_x;
        begin
            case (cur_state)
                S0: get_next_state = (in_x == 1'b0) ? S0 : S1;
                S1: get_next_state = (in_x == 1'b0) ? S1 : S4;
                S2: get_next_state = (in_x == 1'b0) ? S2 : S1;
                S3: get_next_state = (in_x == 1'b0) ? S1 : S2;
                S4: get_next_state = (in_x == 1'b0) ? S3 : S4;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Function to determine output z from state
    function get_output;
        input [2:0] cur_state;
        begin
            case (cur_state)
                S3, S4: get_output = 1'b1;
                default: get_output = 1'b0;
            endcase
        end
    endfunction

    // Synchronous state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= get_next_state(state, x);
    end

    // Output derived by continuous assignment
    assign z = get_output(state);

endmodule