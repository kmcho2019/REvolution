module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding using parameters for clarity
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Function to calculate next state based on current state and input
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                S0: get_next_state = (in_bit) ? S1 : S0;
                S1: get_next_state = (in_bit) ? S1 : S2;
                S2: get_next_state = (in_bit) ? S1 : S3;
                S3: get_next_state = (in_bit) ? S4 : S0;
                S4: get_next_state = (in_bit) ? S1 : S2;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Next state combinational logic
    always @(*) begin
        next_state = get_next_state(state, IN);
    end

    // State register and synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output: MATCH asserted when state reaches S4 (one cycle after final IN=1)
            MATCH <= (state == S4);
        end
    end

endmodule