module fsm(
    input       IN,
    input       CLK,
    input       RST,
    output      MATCH
);

    // Sequence to detect: 1 0 0 1 1
    // State variable indicates how many bits matched so far (0 to 5)
    reg [2:0] state; // 0 to 5 (max 5)
    reg match_reg;

    // Next state combinational logic
    always @(*) begin
        case(state)
            3'd0: begin
                if (IN == 1'b1)
                    match_reg = 0;
                else
                    match_reg = 0;
            end
            default: match_reg = 0;
        endcase
    end

    // Simplify by using the standard prefix function to find next state
    // We'll implement next_state logic using a function that returns the longest prefix matched after reading new input
    // Because the sequence is fixed, we hardcode the logic for the pattern "10011".
    
    // Next state logic function
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case(curr_state)
                3'd0: next_state_func = (in_bit == 1'b1) ? 3'd1 : 3'd0;
                3'd1: next_state_func = (in_bit == 1'b0) ? 3'd2 : 3'd1;
                3'd2: next_state_func = (in_bit == 1'b0) ? 3'd3 : 3'd1;
                3'd3: next_state_func = (in_bit == 1'b1) ? 3'd4 : 3'd0;
                3'd4: next_state_func = (in_bit == 1'b1) ? 3'd5 : 3'd2; // 5 means full match
                3'd5: next_state_func = (in_bit == 1'b1) ? 3'd1 : 3'd2; // After match, restart according to overlap
                default: next_state_func = 3'd0;
            endcase
        end
    endfunction

    // Sequential logic: update state and MATCH on posedge CLK or synchronous reset
    reg match_out;
    always @(posedge CLK) begin
        if (RST) begin
            state <= 3'd0;
            match_out <= 1'b0;
        end else begin
            state <= next_state_func(state, IN);
            // MATCH is asserted when state reaches 5 (full match) and input is 1
            // This occurs in the transition to state 5 when IN == 1, so at that clock cycle MATCH=1
            match_out <= (next_state_func(state, IN) == 3'd5);
        end
    end

    assign MATCH = match_out;

endmodule