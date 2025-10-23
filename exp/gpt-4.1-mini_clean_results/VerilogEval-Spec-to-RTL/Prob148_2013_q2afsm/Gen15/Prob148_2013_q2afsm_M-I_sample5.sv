module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (binary, 2 bits)
    // 2'b00: A (idle)
    // 2'b01: B (grant device 0)
    // 2'b10: C (grant device 1)
    // 2'b11: D (grant device 2)
    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // idle
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            2'b00: begin // A - idle
                // Priority: r0 > r1 > r2
                if      (r[0]) next_state = 2'b01; // grant device 0 (B)
                else if (r[1]) next_state = 2'b10; // grant device 1 (C)
                else if (r[2]) next_state = 2'b11; // grant device 2 (D)
                else           next_state = 2'b00; // stay idle
            end

            2'b01: begin // B - grant device 0
                // Stay granted if r0 persists, else idle
                if (r[0])
                    next_state = 2'b01;
                else
                    next_state = 2'b00;
            end

            2'b10: begin // C - grant device 1
                // Stay granted if r1 persists, else idle
                if (r[1])
                    next_state = 2'b10;
                else
                    next_state = 2'b00;
            end

            2'b11: begin // D - grant device 2
                // Stay granted if r2 persists, else idle
                if (r[2])
                    next_state = 2'b11;
                else
                    next_state = 2'b00;
            end

            default: next_state = 2'b00; // defensive: return to idle
        endcase
    end

    // Output combinational logic: one-hot grant signals
    always @(*) begin
        case (state)
            2'b01: g = 3'b001; // grant device 0
            2'b10: g = 3'b010; // grant device 1
            2'b11: g = 3'b100; // grant device 2
            default: g = 3'b000; // idle, no grants
        endcase
    end

endmodule