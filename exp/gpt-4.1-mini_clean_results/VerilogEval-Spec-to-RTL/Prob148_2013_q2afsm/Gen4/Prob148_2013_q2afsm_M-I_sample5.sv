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

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // state A (idle)
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            2'b00: begin // A (idle)
                if (r[0])
                    next_state = 2'b01; // B grant device 0
                else if (r[1])
                    next_state = 2'b10; // C grant device 1
                else if (r[2])
                    next_state = 2'b11; // D grant device 2
                else
                    next_state = 2'b00; // remain idle
            end
            2'b01: // B grant device 0
                next_state = r[0] ? 2'b01 : 2'b00;
            2'b10: // C grant device 1
                next_state = r[1] ? 2'b10 : 2'b00;
            2'b11: // D grant device 2
                next_state = r[2] ? 2'b11 : 2'b00;
            default:
                next_state = 2'b00; // Should not occur; go idle
        endcase
    end

    // Output logic: g[i] asserted when in corresponding grant state
    always @(*) begin
        case (state)
            2'b01: g = 3'b001; // grant device 0
            2'b10: g = 3'b010; // grant device 1
            2'b11: g = 3'b100; // grant device 2
            default: g = 3'b000; // idle, no grants
        endcase
    end

endmodule