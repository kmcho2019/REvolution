module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (2 bits):
    // 2'b00: Idle (A)
    // 2'b01: Grant device 0 (B)
    // 2'b10: Grant device 1 (C)
    // 2'b11: Grant device 2 (D)
    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // idle state A
        else
            state <= next_state;
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            2'b00: begin // Idle state A
                if      (r[0]) next_state = 2'b01; // Grant device 0 (B)
                else if (r[1]) next_state = 2'b10; // Grant device 1 (C)
                else if (r[2]) next_state = 2'b11; // Grant device 2 (D)
                else           next_state = 2'b00; // Stay idle
            end

            2'b01: begin // Grant device 0 (B)
                if (r[0]) next_state = 2'b01; // Stay granted
                else      next_state = 2'b00; // Return to idle
            end

            2'b10: begin // Grant device 1 (C)
                if (r[1]) next_state = 2'b10; // Stay granted
                else      next_state = 2'b00; // Return to idle
            end

            2'b11: begin // Grant device 2 (D)
                if (r[2]) next_state = 2'b11; // Stay granted
                else      next_state = 2'b00; // Return to idle
            end

            default: next_state = 2'b00; // Safe fallback to idle
        endcase
    end

    // Output logic: only one grant asserted according to state
    always @(*) begin
        case (state)
            2'b00: g = 3'b000; // Idle: no grants
            2'b01: g = 3'b001; // Grant device 0
            2'b10: g = 3'b010; // Grant device 1
            2'b11: g = 3'b100; // Grant device 2
            default: g = 3'b000; // Defensive default
        endcase
    end

endmodule