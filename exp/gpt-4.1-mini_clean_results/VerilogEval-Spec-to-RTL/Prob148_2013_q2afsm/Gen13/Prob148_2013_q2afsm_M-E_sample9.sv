module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    // A = 4'b0001 (idle)
    // B = 4'b0010 (grant device 0)
    // C = 4'b0100 (grant device 1)
    // D = 4'b1000 (grant device 2)
    reg [3:0] state, next_state;

    // Synchronous state register with active-low synchronous reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // Reset to A
        else
            state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        case (state)
            4'b0001: begin // A (idle)
                if (r[0])
                    next_state = 4'b0010; // B grant device 0
                else if (r[1])
                    next_state = 4'b0100; // C grant device 1
                else if (r[2])
                    next_state = 4'b1000; // D grant device 2
                else
                    next_state = 4'b0001; // remain in A
            end
            4'b0010: // B grant device 0
                next_state = (r[0]) ? 4'b0010 : 4'b0001;
            4'b0100: // C grant device 1
                next_state = (r[1]) ? 4'b0100 : 4'b0001;
            4'b1000: // D grant device 2
                next_state = (r[2]) ? 4'b1000 : 4'b0001;
            default:
                next_state = 4'b0001; // safe reset to A
        endcase
    end

    // Output grants assigned directly from one-hot state bits
    assign g[0] = state[1]; // B
    assign g[1] = state[2]; // C
    assign g[2] = state[3]; // D

endmodule