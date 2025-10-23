module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparam and enumerated values for clarity
    localparam [1:0]
        S_IDLE = 2'd0,
        S_1    = 2'd1,
        S_10   = 2'd2;

    reg [1:0] state, next_state;

    // Next state function: combinational logic separated into a function for clarity
    function [1:0] get_next_state(input [1:0] curr_state, input x_in);
        begin
            case (curr_state)
                S_IDLE: get_next_state = x_in ? S_1  : S_IDLE;
                S_1:    get_next_state = x_in ? S_1  : S_10;
                S_10:   get_next_state = x_in ? S_1  : S_IDLE;
                default:get_next_state = S_IDLE;
            endcase
        end
    endfunction

    // Sequential block: state update and output generation with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S_IDLE;
            z     <= 1'b0;
        end else begin
            state <= get_next_state(state, x);

            // Moore output logic: output asserted when current state is S_10
            // (which means the sequence "10" has been detected so far),
            // and previous input x caused transition to this state.
            // For "101" detection, output is 1 when in S_10 state and input x was 1 before transition.
            // Since output is registered here, it reflects detection of sequence on the previous cycle.
            z <= (state == S_10);
        end
    end

endmodule