module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// State encoding
localparam S0 = 3'd0; // no match
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched "11"
localparam S3 = 3'd3; // matched "110"
localparam S4 = 3'd4; // matched "1101" (final)

reg [2:0] state;

// Combinational function to calculate next state
function [2:0] next_state_func;
    input [2:0] current_state;
    input       bit_in;
    begin
        case (current_state)
            S0: next_state_func = bit_in ? S1 : S0;
            S1: next_state_func = bit_in ? S2 : S0;
            S2: next_state_func = bit_in ? S2 : S3;
            S3: next_state_func = bit_in ? S4 : S0;
            S4: next_state_func = S4;
            default: next_state_func = S0;
        endcase
    end
endfunction

wire [2:0] next_state = next_state_func(state, data);

// Sequential state update and output register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        // start_shifting asserted once in S4 and stays asserted until reset
        if (state == S4)
            start_shifting <= 1'b1;
    end
end

endmodule