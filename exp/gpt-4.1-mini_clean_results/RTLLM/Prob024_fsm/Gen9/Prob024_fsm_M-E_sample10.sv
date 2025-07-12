module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);
    // Pattern: 1 0 0 1 1
    // States represent how many bits matched so far: 0..5
    // State encoding: binary 3-bit state
    reg [2:0] state, next_state;

    // Function to compute next state given current state and input bit,
    // handling overlapping sequences by finding the longest prefix suffix.
    function [2:0] f_next_state;
        input [2:0] curr_state;
        input        bit_in;
        begin
            // Pattern bits for reference: p[0]=1, p[1]=0, p[2]=0, p[3]=1, p[4]=1
            // We'll try to extend matched prefix by one bit, or fallback properly.
            case (curr_state)
                3'd0: begin
                    if (bit_in == 1'b1) f_next_state = 3'd1; else f_next_state = 3'd0;
                end
                3'd1: begin
                    if (bit_in == 1'b0) f_next_state = 3'd2;
                    else if (bit_in == 1'b1) f_next_state = 3'd1; // start over with first bit matched
                    else f_next_state = 3'd0;
                end
                3'd2: begin
                    if (bit_in == 1'b0) f_next_state = 3'd3;
                    else if (bit_in == 1'b1) f_next_state = 3'd1;
                    else f_next_state = 3'd0;
                end
                3'd3: begin
                    if (bit_in == 1'b1) f_next_state = 3'd4;
                    else f_next_state = 3'd0;
                end
                3'd4: begin
                    if (bit_in == 1'b1) f_next_state = 3'd5; // full match
                    else if (bit_in == 1'b0) f_next_state = 3'd2; // partial overlap restart
                    else f_next_state = 3'd0;
                end
                3'd5: begin
                    // After full match, process next input for overlapping pattern
                    if (bit_in == 1'b1) f_next_state = 3'd1;
                    else if (bit_in == 1'b0) f_next_state = 3'd2;
                    else f_next_state = 3'd0;
                end
                default: f_next_state = 3'd0;
            endcase
        end
    endfunction

    // Next state logic combinational
    always @(*) begin
        next_state = f_next_state(state, IN);
    end

    // State update synchronous with CLK and synchronous active-high reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // MATCH is Mealy output: asserted combinationally when next_state is full match (5)
    // at the time last input bit is received.
    assign MATCH = (next_state == 3'd5);

endmodule