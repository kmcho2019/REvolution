module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states
reg [1:0] state; // Reduced from 3 bits to 2 bits to minimize area
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= A; // Reset to state A
    else begin
        case (state)
            A: begin
                if (r[0]) state <= B; // Priority to device 0
                else if (r[1]) state <= C; // Priority to device 1
                else if (r[2]) state <= D; // Priority to device 2
                else state <= A; // Stay in state A if no requests
            end
            B: state <= r[0]? B : A; // Stay in state B if device 0 is requesting
            C: state <= r[1]? C : A; // Stay in state C if device 1 is requesting
            D: state <= r[2]? D : A; // Stay in state D if device 2 is requesting
            default: state <= A; // Default to state A
        endcase
    end
end

// Output logic
assign g[0] = (state == B); // Set g[0] to 1 if in state B
assign g[1] = (state == C); // Set g[1] to 1 if in state C
assign g[2] = (state == D); // Set g[2] to 1 if in state D

endmodule