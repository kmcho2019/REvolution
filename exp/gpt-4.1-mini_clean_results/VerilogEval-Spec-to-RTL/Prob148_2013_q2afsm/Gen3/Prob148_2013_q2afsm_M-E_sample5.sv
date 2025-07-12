module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State bits: one-hot style encoding for grants
    // 3'b000 = idle (A)
    // 3'b001 = grant device 0 (B)
    // 3'b010 = grant device 1 (C)
    // 3'b100 = grant device 2 (D)
    reg [2:0] state, next_state;

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 3'b000; // idle state A
        else
            state <= next_state;
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            3'b000: begin // idle A
                if (r[0])
                    next_state = 3'b001; // grant device 0 (B)
                else if (r[1])
                    next_state = 3'b010; // grant device 1 (C)
                else if (r[2])
                    next_state = 3'b100; // grant device 2 (D)
                else
                    next_state = 3'b000; // remain idle
            end

            3'b001: // grant device 0 (B)
                next_state = r[0] ? 3'b001 : 3'b000;

            3'b010: // grant device 1 (C)
                next_state = r[1] ? 3'b010 : 3'b000;

            3'b100: // grant device 2 (D)
                next_state = r[2] ? 3'b100 : 3'b000;

            default: // illegal or unused states, reset to idle
                next_state = 3'b000;
        endcase
    end

    // Output grant signals correspond directly to one-hot state bits
    assign g = state;

endmodule