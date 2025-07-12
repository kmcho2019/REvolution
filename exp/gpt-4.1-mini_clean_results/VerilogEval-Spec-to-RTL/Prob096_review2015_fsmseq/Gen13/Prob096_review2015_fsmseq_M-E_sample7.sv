module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding: represents how many bits matched in "1101" sequence
    localparam S0    = 3'd0; // No match yet
    localparam S1    = 3'd1; // Matched '1'
    localparam S2    = 3'd2; // Matched '11'
    localparam S3    = 3'd3; // Matched '110'
    localparam FOUND = 3'd4; // Matched '1101' sequence fully

    reg [2:0] state;

    // Next state combinational function
    function [2:0] next_state_func(input [2:0] curr_state, input bit_in);
        begin
            case (curr_state)
                S0: next_state_func = bit_in ? S1 : S0;
                S1: next_state_func = bit_in ? S2 : S0;
                S2: next_state_func = bit_in ? S2 : S3;
                S3: next_state_func = bit_in ? FOUND : S0;
                FOUND: next_state_func = FOUND; // Sticky detected state
                default: next_state_func = S0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_func(state, data);
    end

    assign start_shifting = (state == FOUND);

endmodule