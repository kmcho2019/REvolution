module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output wire z
);

    // State encoding: 3 states for sequence "101" detection
    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state;

    // Next-state combinational logic function
    function [1:0] get_next_state(input [1:0] curr_state, input x_in);
        begin
            case (curr_state)
                S0: get_next_state = x_in ? S1 : S0;
                S1: get_next_state = x_in ? S1 : S2;
                S2: get_next_state = x_in ? S1 : S0;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Next state wire for combinational logic
    wire [1:0] next_state = get_next_state(state, x);

    // Mealy output logic as combinational assign
    assign z = (state == S2) && x;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule