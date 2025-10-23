module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding as 2-bit binary:
    // 00: A idle
    // 01: B grant device 0
    // 10: C grant device 1
    // 11: D grant device 2
    reg [1:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // idle state A
        else
            state <= next_state;
    end

    // Next-state logic combinational block
    always @(*) begin
        case(state)
            2'b00: begin // A idle
                if (r[0])
                    next_state = 2'b01; // B grant device 0
                else if (r[1])
                    next_state = 2'b10; // C grant device 1
                else if (r[2])
                    next_state = 2'b11; // D grant device 2
                else
                    next_state = 2'b00; // stay idle
            end

            2'b01: // B grant device 0
                next_state = r[0] ? 2'b01 : 2'b00;

            2'b10: // C grant device 1
                next_state = r[1] ? 2'b10 : 2'b00;

            2'b11: // D grant device 2
                next_state = r[2] ? 2'b11 : 2'b00;

            default:
                next_state = 2'b00; // safety fallback to idle
        endcase
    end

    // Output logic using continuous assignments:
    // grant device 0 if state == 01
    // grant device 1 if state == 10
    // grant device 2 if state == 11
    assign g[0] = (state == 2'b01) ? 1'b1 : 1'b0;
    assign g[1] = (state == 2'b10) ? 1'b1 : 1'b0;
    assign g[2] = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule