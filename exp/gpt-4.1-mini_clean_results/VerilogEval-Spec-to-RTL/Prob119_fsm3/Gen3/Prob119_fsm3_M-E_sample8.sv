module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding using 4-bit vector
    // A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
    reg [3:0] state, next_state;

    // Asynchronous positive edge reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 4'b0001; // State A
        else
            state <= next_state;
    end

    // Next state and output logic combinational block
    always @(*) begin
        // Defaults: hold current state, output zero
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            4'b0001: begin // A
                out = 1'b0;
                next_state = (in) ? 4'b0010 : 4'b0001; // B if in=1 else A
            end
            4'b0010: begin // B
                out = 1'b0;
                next_state = (in) ? 4'b0010 : 4'b0100; // B if in=1 else C
            end
            4'b0100: begin // C
                out = 1'b0;
                next_state = (in) ? 4'b1000 : 4'b0001; // D if in=1 else A
            end
            4'b1000: begin // D
                out = 1'b1;
                next_state = (in) ? 4'b0010 : 4'b0100; // B if in=1 else C
            end
            default: begin
                next_state = 4'b0001; // Reset to A if invalid state
                out = 1'b0;
            end
        endcase
    end

endmodule