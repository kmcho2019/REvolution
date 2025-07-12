module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Function to determine next state based on current state and input
    function [1:0] get_next_state;
        input [1:0] curr_state;
        input in_bit;
        begin
            case (curr_state)
                A: get_next_state = in_bit ? B : A;
                B: get_next_state = in_bit ? B : C;
                C: get_next_state = in_bit ? D : A;
                D: get_next_state = in_bit ? B : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Function to determine output based on current state (Moore FSM)
    function get_output;
        input [1:0] curr_state;
        begin
            get_output = (curr_state == D) ? 1'b1 : 1'b0;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= get_next_state(state, in);
            out <= get_output(state);
        end
    end

endmodule