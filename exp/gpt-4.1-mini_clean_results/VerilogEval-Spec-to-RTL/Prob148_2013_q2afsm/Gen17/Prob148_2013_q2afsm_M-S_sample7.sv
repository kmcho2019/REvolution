module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (2-bit binary)
    // 2'b00 = A (idle)
    // 2'b01 = B (grant device 0)
    // 2'b10 = C (grant device 1)
    // 2'b11 = D (grant device 2)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // state A (idle)
        else
            state <= next_state;
    end

    // Next-state logic with priority and hold grants
    always @(*) begin
        case (state)
            2'b00: begin // A
                if (r[0])
                    next_state = 2'b01; // B
                else if (r[1])
                    next_state = 2'b10; // C
                else if (r[2])
                    next_state = 2'b11; // D
                else
                    next_state = 2'b00; // stay A
            end

            2'b01: // B
                next_state = r[0] ? 2'b01 : 2'b00;

            2'b10: // C
                next_state = r[1] ? 2'b10 : 2'b00;

            2'b11: // D
                next_state = r[2] ? 2'b11 : 2'b00;

            default:
                next_state = 2'b00; // safety fallback
        endcase
    end

    // Output logic decoding grants based on state
    always @(*) begin
        case (state)
            2'b01: g = 3'b001; // grant device 0
            2'b10: g = 3'b010; // grant device 1
            2'b11: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant
        endcase
    end

endmodule