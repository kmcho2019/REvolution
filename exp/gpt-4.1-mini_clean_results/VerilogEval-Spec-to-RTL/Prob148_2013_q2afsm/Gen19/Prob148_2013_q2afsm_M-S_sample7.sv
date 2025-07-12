module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2-bit binary):
    // 2'b00: Idle (A)
    // 2'b01: Grant device 0 (B)
    // 2'b10: Grant device 1 (C)
    // 2'b11: Grant device 2 (D)
    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00;  // idle state A
        else
            state <= next_state;
    end

    // Next state combinational logic with priority
    always @(*) begin
        case (state)
            2'b00: begin // idle A
                if      (r[0]) next_state = 2'b01; // grant device 0 B
                else if (r[1]) next_state = 2'b10; // grant device 1 C
                else if (r[2]) next_state = 2'b11; // grant device 2 D
                else           next_state = 2'b00; // stay idle
            end
            2'b01: begin // grant device 0 B
                if (r[0])
                    next_state = 2'b01; // stay grant 0
                else
                    next_state = 2'b00; // back to idle
            end
            2'b10: begin // grant device 1 C
                if (r[1])
                    next_state = 2'b10; // stay grant 1
                else
                    next_state = 2'b00; // back to idle
            end
            2'b11: begin // grant device 2 D
                if (r[2])
                    next_state = 2'b11; // stay grant 2
                else
                    next_state = 2'b00; // back to idle
            end
            default: next_state = 2'b00; // safety default
        endcase
    end

    // Output grant signals decoded from state
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
               3'b000;

endmodule