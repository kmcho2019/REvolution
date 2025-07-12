module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits)
    // A = 2'b00 (idle)
    // B = 2'b01 (grant device 0)
    // C = 2'b10 (grant device 1)
    // D = 2'b11 (grant device 2)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // Reset to state A (idle)
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            2'b00: begin // State A (idle)
                if (r[0])
                    next_state = 2'b01; // grant device 0 (B)
                else if (r[1])
                    next_state = 2'b10; // grant device 1 (C)
                else if (r[2])
                    next_state = 2'b11; // grant device 2 (D)
                else
                    next_state = 2'b00; // remain idle
            end
            2'b01: // State B (grant device 0)
                next_state = r[0] ? 2'b01 : 2'b00;
            2'b10: // State C (grant device 1)
                next_state = r[1] ? 2'b10 : 2'b00;
            2'b11: // State D (grant device 2)
                next_state = r[2] ? 2'b11 : 2'b00;
            default:
                next_state = 2'b00;
        endcase
    end

    // Output logic: grant signal 'g' derived combinationally from the state
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
               3'b000;

endmodule