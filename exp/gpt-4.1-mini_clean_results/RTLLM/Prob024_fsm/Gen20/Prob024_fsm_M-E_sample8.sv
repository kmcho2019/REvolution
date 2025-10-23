module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Sequence to detect: 1 0 0 1 1
    // Length of sequence:
    localparam SEQ_LEN = 5;

    // State represents how many characters matched so far (0 to 5)
    reg [2:0] state, next_state;

    // Function to compute next prefix length based on current prefix and input bit
    // This implements prefix function similar to KMP algorithm.
    // Returns next matched prefix length (0 to SEQ_LEN)
    function [2:0] prefix_func;
        input [2:0] current_state;
        input        in_bit;
        begin
            // The sequence: S = 1 0 0 1 1
            // States: number of matched chars so far
            // We check what is the longest prefix of S that matches suffix ending with in_bit
            case (current_state)
                3'd0: prefix_func = (in_bit == 1'b1) ? 3'd1 : 3'd0;
                3'd1: prefix_func = (in_bit == 1'b0) ? 3'd2 :
                                    (in_bit == 1'b1) ? 3'd1 : 3'd0;
                3'd2: prefix_func = (in_bit == 1'b0) ? 3'd3 :
                                    (in_bit == 1'b1) ? 3'd1 : 3'd0;
                3'd3: prefix_func = (in_bit == 1'b1) ? 3'd4 :
                                    (in_bit == 1'b0) ? 3'd0 : 3'd0;
                3'd4: prefix_func = (in_bit == 1'b1) ? 3'd5 :  // Full match after this input
                                    (in_bit == 1'b0) ? 3'd2 : 3'd0;
                3'd5: prefix_func = (in_bit == 1'b1) ? 3'd1 :
                                    (in_bit == 1'b0) ? 3'd2 : 3'd0;
                default: prefix_func = 3'd0;
            endcase
        end
    endfunction

    // Update state on posedge CLK or RST synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = prefix_func(state, IN);
    end

    // MATCH is asserted when full sequence matched (state 4 + input=1) causes next_state = 5
    assign MATCH = (next_state == 3'd5);

endmodule