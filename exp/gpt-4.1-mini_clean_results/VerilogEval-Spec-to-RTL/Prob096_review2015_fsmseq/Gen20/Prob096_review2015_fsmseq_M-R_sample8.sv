module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding
    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    reg [2:0] state;

    // Next state combinational function
    function [2:0] next_state_func(input [2:0] curr_state, input bit);
        begin
            case (curr_state)
                S0: next_state_func = bit ? S1 : S0;
                S1: next_state_func = bit ? S2 : S0;
                S2: next_state_func = bit ? S2 : S3;
                S3: next_state_func = bit ? S4 : S0;
                S4: next_state_func = S4; // sticky detected state
                default: next_state_func = S0;
            endcase
        end
    endfunction

    wire [2:0] next_state = next_state_func(state, data);

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore output
    assign start_shifting = (state == S4);

endmodule