module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state;

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // Function to determine next state based on current state and input x
    function [2:0] next_state_func(input [2:0] curr_state, input x_in);
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

    // Sequential logic: state and output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state_func(state, x);
            // Output z is registered, set according to next state
            // According to table, output depends on current state (not next), so use current state
            z <= (state == S3) || (state == S4);
        end
    end

endmodule