module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2-bit binary)
    // 2'b00 = A (idle)
    // 2'b01 = B (grant device 0)
    // 2'b10 = C (grant device 1)
    // 2'b11 = D (grant device 2)
    reg [1:0] state;

    // Function to calculate next state based on current state and input requests
    function [1:0] next_state_f;
        input [1:0] current_state;
        input [2:0] requests;
        begin
            case (current_state)
                2'b00: begin // A
                    if (requests[0])
                        next_state_f = 2'b01; // B
                    else if (requests[1])
                        next_state_f = 2'b10; // C
                    else if (requests[2])
                        next_state_f = 2'b11; // D
                    else
                        next_state_f = 2'b00; // stay A
                end
                2'b01: next_state_f = requests[0] ? 2'b01 : 2'b00; // B
                2'b10: next_state_f = requests[1] ? 2'b10 : 2'b00; // C
                2'b11: next_state_f = requests[2] ? 2'b11 : 2'b00; // D
                default: next_state_f = 2'b00;
            endcase
        end
    endfunction

    wire [1:0] next_state;
    assign next_state = next_state_f(state, r);

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // reset to A
        else
            state <= next_state;
    end

    // Grant outputs assigned continuously based on current state
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
                                  3'b000;

endmodule