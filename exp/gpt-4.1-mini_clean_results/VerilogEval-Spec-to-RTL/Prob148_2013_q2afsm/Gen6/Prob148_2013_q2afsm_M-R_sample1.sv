module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // Function to determine next state based on current state and input r
    function [1:0] get_next_state;
        input [1:0] curr_state;
        input [2:0] req;
        begin
            case(curr_state)
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
            state <= next_state;
    end

    // Compute next state using the function
    always @(*) begin
        next_state = get_next_state(state, r);
    end

    // Output logic assigned combinationally via assign
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule