module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (2 bits)
    // A = 2'b00 (idle)
    // B = 2'b01 (grant device 0)
    // C = 2'b10 (grant device 1)
    // D = 2'b11 (grant device 2)
    reg [1:0] state, next_state;

    // Sequential block: synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // reset to idle A
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        case (state)
            2'b00: begin // A (idle)
                if (r[0])
                    next_state = 2'b01; // B: grant device 0
                else if (r[1])
                    next_state = 2'b10; // C: grant device 1
                else if (r[2])
                    next_state = 2'b11; // D: grant device 2
                else
                    next_state = 2'b00; // remain idle
            end
            2'b01: begin // B (grant device 0)
                if (r[0])
                    next_state = 2'b01; // stay granting device 0
                else
                    next_state = 2'b00; // go idle
            end
            2'b10: begin // C (grant device 1)
                if (r[1])
                    next_state = 2'b10; // stay granting device 1
                else
                    next_state = 2'b00; // go idle
            end
            2'b11: begin // D (grant device 2)
                if (r[2])
                    next_state = 2'b11; // stay granting device 2
                else
                    next_state = 2'b00; // go idle
            end
            default: next_state = 2'b00; // safety fallback to idle
        endcase
    end

    // Output logic: combinational mapping state -> g
    always @(*) begin
        case (state)
            2'b01: g = 3'b001; // grant device 0
            2'b10: g = 3'b010; // grant device 1
            2'b11: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant in idle
        endcase
    end

endmodule