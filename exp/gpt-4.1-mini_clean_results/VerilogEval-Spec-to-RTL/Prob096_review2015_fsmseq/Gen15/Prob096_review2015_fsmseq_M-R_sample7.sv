module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding
    localparam S0    = 3'd0;
    localparam S1    = 3'd1;
    localparam S11   = 3'd2;
    localparam S110  = 3'd3;
    localparam S1101 = 3'd4;

    reg [2:0] state;

    // Function to determine next state based on current state and input data
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input data_in;
        begin
            case (curr_state)
                S0:    next_state_func = data_in ? S1    : S0;
                S1:    next_state_func = data_in ? S11   : S0;
                S11:   next_state_func = data_in ? S11   : S110;
                S110:  next_state_func = data_in ? S1101 : S0;
                S1101: next_state_func = S1101;  // latch detected state
                default: next_state_func = S0;
            endcase
        end
    endfunction

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_func(state, data);
    end

    // Moore output
    assign start_shifting = (state == S1101);

endmodule