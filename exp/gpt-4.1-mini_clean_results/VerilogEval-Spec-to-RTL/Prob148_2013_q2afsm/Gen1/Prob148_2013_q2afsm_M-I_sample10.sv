module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 2'b00 = A (idle), 01 = B (grant 0), 10 = C (grant 1), 11 = D (grant 2)
    reg [1:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // A
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            2'b00: begin // A (Idle)
                if (r[0])
                    next_state = 2'b01; // B: grant device 0
                else if (r[1])
                    next_state = 2'b10; // C: grant device 1
                else if (r[2])
                    next_state = 2'b11; // D: grant device 2
                else
                    next_state = 2'b00; // stay idle
            end
            2'b01: // B: grant device 0
                next_state = r[0] ? 2'b01 : 2'b00;
            2'b10: // C: grant device 1
                next_state = r[1] ? 2'b10 : 2'b00;
            2'b11: // D: grant device 2
                next_state = r[2] ? 2'b11 : 2'b00;
            default:
                next_state = 2'b00;
        endcase
    end

    // Output logic: grant outputs based on state (one-hot)
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
               3'b000;

endmodule