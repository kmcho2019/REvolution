module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // Next state combinational logic as a function
    function [2:0] next_state_func;
        input [2:0] current_state;
        input x_in;
        begin
            case (current_state)
                S0: next_state_func = x_in ? S1 : S0;
                S1: next_state_func = x_in ? S4 : S1;
                S2: next_state_func = x_in ? S1 : S2;
                S3: next_state_func = x_in ? S2 : S1;
                S4: next_state_func = x_in ? S4 : S3;
                default: next_state_func = S0;
            endcase
        end
    endfunction

    // Assign next state based on current state and input
    wire [2:0] next_state = next_state_func(state, x);

    // Output z combinationally assigned based on current state
    assign z = (state == S3) || (state == S4);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule