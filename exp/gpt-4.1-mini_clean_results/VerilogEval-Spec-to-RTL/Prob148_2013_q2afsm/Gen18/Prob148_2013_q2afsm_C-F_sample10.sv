module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2-bit binary):
    // 2'b00: A (idle)
    // 2'b01: B (grant device 0)
    // 2'b10: C (grant device 1)
    // 2'b11: D (grant device 2)
    reg [1:0] state, next_state;

    // Sequential logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // idle state A
        else
            state <= next_state;
    end

    // Next state logic with priority encoding and sustain
    always @(*) begin
        case (state)
            2'b00: begin // A (idle)
                if      (r[0]) next_state = 2'b01; // grant device 0 (B)
                else if (r[1]) next_state = 2'b10; // grant device 1 (C)
                else if (r[2]) next_state = 2'b11; // grant device 2 (D)
                else           next_state = 2'b00; // remain idle
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

    // Output grants decoded from state
    assign g[0] = (state == 2'b01); // grant device 0
    assign g[1] = (state == 2'b10); // grant device 1
    assign g[2] = (state == 2'b11); // grant device 2

endmodule