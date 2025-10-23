module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary)
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state, next_state;

    // Function for next state logic
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                S0: get_next_state = (in_bit == 1'b1) ? S1 : S0;
                S1: get_next_state = (in_bit == 1'b0) ? S2 : S1;
                S2: get_next_state = (in_bit == 1'b0) ? S3 : S1;
                S3: get_next_state = (in_bit == 1'b1) ? S4 : S0;
                S4: get_next_state = (in_bit == 1'b1) ? S5 : S2;
                S5: get_next_state = (in_bit == 1'b0) ? S2 : S1;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Next state logic computed combinationally via assign for clarity
    always @(*) begin
        next_state = get_next_state(state, IN);
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational Mealy output MATCH assigned via assign statement
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule