module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (2-bit binary)
    // 00: A (idle)
    // 01: B (grant device 0)
    // 10: C (grant device 1)
    // 11: D (grant device 2)
    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // A
        else
            state <= next_state;
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            2'b00: begin // State A
                // Priority: r[0] > r[1] > r[2]
                if (r[0])
                    next_state = 2'b01; // B
                else if (r[1])
                    next_state = 2'b10; // C
                else if (r[2])
                    next_state = 2'b11; // D
                else
                    next_state = 2'b00; // stay A
            end

            2'b01: // State B (grant device 0)
                next_state = r[0] ? 2'b01 : 2'b00;

            2'b10: // State C (grant device 1)
                next_state = r[1] ? 2'b10 : 2'b00;

            2'b11: // State D (grant device 2)
                next_state = r[2] ? 2'b11 : 2'b00;

            default:
                next_state = 2'b00; // safety fallback
        endcase
    end

    // Output logic combinationally determined by state
    always @(*) begin
        case (state)
            2'b01: g = 3'b001; // grant device 0
            2'b10: g = 3'b010; // grant device 1
            2'b11: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant
        endcase
    end

endmodule