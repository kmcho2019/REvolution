module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11, E = 4'b1000, F = 4'b1001;

reg [3:0] state;

// Initialize state machine
initial state = A;

// State transitions
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end else begin
        case (state)
            A: if (w) state <= A; else state <= B;
            B: if (w) state <= D; else state <= C;
            C: if (w) state <= D; else state <= E;
            D: if (w) state <= A; else state <= F;
            E: if (w) state <= D; else state <= E;
            F: if (w) state <= D; else state <= C;
            default: state <= A;
        endcase
        // Assign output z based on the current state
        if (state == E || state == F) z <= 1;
        else z <= 0;
    end
end

endmodule