module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    // State encoding
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // Next state function
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

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_func(state, x);
    end

    // Output logic as combinational expression: z=1 when state is S3 or S4
    assign z = (state == S3) || (state == S4);

endmodule