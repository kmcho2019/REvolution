module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits)
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] state, next_state;

    // Function to determine next state based on current state and inputs
    function [1:0] get_next_state;
        input [1:0] curr_state;
        input [2:0] req;
        begin
            case (curr_state)
                A: begin
                    if (req[0])
                        get_next_state = B;
                    else if (req[1])
                        get_next_state = C;
                    else if (req[2])
                        get_next_state = D;
                    else
                        get_next_state = A;
                end
                B: get_next_state = req[0] ? B : A;
                C: get_next_state = req[1] ? C : A;
                D: get_next_state = req[2] ? D : A;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= get_next_state(state, r);
    end

    // Continuous assignment for output grants based on state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
               3'b000;

endmodule