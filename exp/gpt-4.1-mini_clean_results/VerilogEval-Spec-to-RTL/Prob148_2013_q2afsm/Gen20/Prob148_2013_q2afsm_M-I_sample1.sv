module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding (4 bits)
    // A = 4'b0001 (idle)
    // B = 4'b0010 (grant device 0)
    // C = 4'b0100 (grant device 1)
    // D = 4'b1000 (grant device 2)
    reg [3:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // A idle state
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        // Default: hold current state
        next_state = 4'b0000;
        case (1'b1) // one-hot style case
            state[0]: begin // A
                if (r[0])
                    next_state = 4'b0010; // B grant device 0
                else if (r[1])
                    next_state = 4'b0100; // C grant device 1
                else if (r[2])
                    next_state = 4'b1000; // D grant device 2
                else
                    next_state = 4'b0001; // remain A
            end
            state[1]: begin // B
                next_state = r[0] ? 4'b0010 : 4'b0001;
            end
            state[2]: begin // C
                next_state = r[1] ? 4'b0100 : 4'b0001;
            end
            state[3]: begin // D
                next_state = r[2] ? 4'b1000 : 4'b0001;
            end
            default: next_state = 4'b0001; // safe fallback to A
        endcase
    end

    // Outputs: grant signals based on state bits
    assign g[0] = state[1]; // B grants device 0
    assign g[1] = state[2]; // C grants device 1
    assign g[2] = state[3]; // D grants device 2

endmodule