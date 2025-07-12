module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // One-hot state encoding
    localparam WAIT_FOR_FIRST_ZERO  = 3'b001;
    localparam WAIT_FOR_ONE         = 3'b010;
    localparam WAIT_FOR_SECOND_ZERO = 3'b100;

    reg [2:0] state, next_state;

    // Combinational next_state logic as a function
    function [2:0] get_next_state(input [2:0] cur_state, input data);
        begin
            case (cur_state)
                WAIT_FOR_FIRST_ZERO: 
                    if (data == 1'b0)
                        get_next_state = WAIT_FOR_ONE;
                    else
                        get_next_state = WAIT_FOR_FIRST_ZERO;
                WAIT_FOR_ONE:
                    if (data == 1'b1)
                        get_next_state = WAIT_FOR_SECOND_ZERO;
                    else
                        get_next_state = WAIT_FOR_FIRST_ZERO;
                WAIT_FOR_SECOND_ZERO:
                    if (data == 1'b0)
                        get_next_state = WAIT_FOR_FIRST_ZERO;
                    else
                        get_next_state = WAIT_FOR_SECOND_ZERO;
                default: get_next_state = WAIT_FOR_FIRST_ZERO;
            endcase
        end
    endfunction

    // State register with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= WAIT_FOR_FIRST_ZERO;
        else
            state <= get_next_state(state, data_in);
    end

    // Combinational data_out: pulse detected if in WAIT_FOR_SECOND_ZERO and input zero (meaning next_state will be WAIT_FOR_FIRST_ZERO)
    assign data_out = (state == WAIT_FOR_SECOND_ZERO) && (data_in == 1'b0);

endmodule