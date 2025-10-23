module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Sequence to detect: 1 0 0 1 1
    // States represent how many bits matched so far: 0..5
    // State 5 means full match detected

    reg [2:0] state, next_state;

    // Function to compute fallback state based on current prefix and new input
    // This mimics the longest prefix-suffix function from KMP algorithm,
    // implemented combinationally for this fixed pattern.

    function [2:0] next_state_func(input [2:0] curr_state, input bit_in);
        begin
            case (curr_state)
                3'd0: next_state_func = (bit_in == 1'b1) ? 3'd1 : 3'd0;
                3'd1: next_state_func = (bit_in == 1'b0) ? 3'd2 : 3'd1;
                3'd2: next_state_func = (bit_in == 1'b0) ? 3'd3 : 3'd1;
                3'd3: next_state_func = (bit_in == 1'b1) ? 3'd4 : 3'd0;
                3'd4: next_state_func = (bit_in == 1'b1) ? 3'd5 : 3'd2;
                3'd5: next_state_func = (bit_in == 1'b1) ? 3'd1 : 3'd2; // after full match, continue detection
                default: next_state_func = 3'd0;
            endcase
        end
    endfunction

    // Compute next state combinationally
    always @(*) begin
        next_state = next_state_func(state, IN);
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // MATCH is asserted combinationally when next_state equals 5 (full match)
    assign MATCH = (next_state == 3'd5);

endmodule