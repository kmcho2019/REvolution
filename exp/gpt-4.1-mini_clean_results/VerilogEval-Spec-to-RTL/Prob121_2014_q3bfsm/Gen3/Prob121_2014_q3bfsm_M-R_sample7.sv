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

    wire [2:0] next_state;

    // Next state combinational logic as a function
    function [2:0] calc_next_state;
        input [2:0] curr_state;
        input x_in;
        begin
            case (curr_state)
                S0: calc_next_state = x_in ? S1 : S0;
                S1: calc_next_state = x_in ? S4 : S1;
                S2: calc_next_state = x_in ? S1 : S2;
                S3: calc_next_state = x_in ? S2 : S1;
                S4: calc_next_state = x_in ? S4 : S3;
                default: calc_next_state = S0;
            endcase
        end
    endfunction

    assign next_state = calc_next_state(state, x);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output z combinationally assigned based on state
    assign z = (state == S3) || (state == S4);

endmodule