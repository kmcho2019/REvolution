module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding representing matched prefix of "10011":
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    reg [2:0] state;

    // Function to determine next state based on current state and input IN
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                3'd0: get_next_state = (in_bit) ? 3'd1 : 3'd0;
                3'd1: get_next_state = (in_bit) ? 3'd1 : 3'd2;
                3'd2: get_next_state = (in_bit) ? 3'd1 : 3'd3;
                3'd3: get_next_state = (in_bit) ? 3'd4 : 3'd0;
                3'd4: get_next_state = (in_bit) ? 3'd1 : 3'd2;
                default: get_next_state = 3'd0;
            endcase
        end
    endfunction

    // Next state wire computed combinationally using the function
    wire [2:0] next_state = get_next_state(state, IN);

    // Synchronous state update on positive clock edge with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is combinational, asserted when state==4 and IN==1
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule