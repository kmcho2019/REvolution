module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // Declare states as localparams for readability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state, next_state;

    // Function for next state logic
    function [2:0] calc_next_state;
        input [2:0] curr_state;
        input x_in;
        begin
            case(curr_state)
                S0: calc_next_state = (x_in) ? S1 : S0;
                S1: calc_next_state = (x_in) ? S4 : S1;
                S2: calc_next_state = (x_in) ? S1 : S2;
                S3: calc_next_state = (x_in) ? S2 : S1;
                S4: calc_next_state = (x_in) ? S4 : S3;
                default: calc_next_state = S0;
            endcase
        end
    endfunction

    // Function for output logic based on current state
    function output_z;
        input [2:0] curr_state;
        begin
            case(curr_state)
                S3: output_z = 1'b1;
                S4: output_z = 1'b1;
                default: output_z = 1'b0;
            endcase
        end
    endfunction

    // Sequential logic: state update and synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic and output calculation
    always @(*) begin
        next_state = calc_next_state(state, x);
        z = output_z(state);
    end

endmodule