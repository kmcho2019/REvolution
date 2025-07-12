module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State bits one-hot: s0 - s7
    reg [7:0] state;

    // Function to compute next state based on current state and input
    function [7:0] next_state_func;
        input [7:0] curr_state;
        input       in_bit;
        begin
            if (in_bit == 1'b0) begin
                next_state_func = 8'b0000_0001; // s0
            end else begin
                if (curr_state[7]) begin
                    next_state_func = 8'b1000_0000; // s7 stays s7
                end else begin
                    next_state_func = curr_state << 1; // shift left one-hot
                end
            end
        end
    endfunction

    // Next state wire
    wire [7:0] next_state = next_state_func(state, in);

    // Outputs combinationally derived from current state and input (Moore outputs)
    wire disc_w = state[5] && (in == 1'b0); // 5 consecutive 1s then 0
    wire flag_w = state[6] && (in == 1'b0); // 6 consecutive 1s then 0
    wire err_w  = next_state[7];             // next state is error state s7

    // Sequential logic for state update and output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b0000_0001; // s0 on reset
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule