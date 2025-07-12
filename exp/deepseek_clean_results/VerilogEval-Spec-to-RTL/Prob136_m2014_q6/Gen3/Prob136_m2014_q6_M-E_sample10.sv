module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// State encoding (compact binary)
parameter [2:0] A = 3'b000,
                B = 3'b001,
                C = 3'b010,
                D = 3'b011,
                E = 3'b100,
                F = 3'b101;

reg [2:0] current_state, next_state;
reg [2:0] w0_path, w1_path; // Pre-computed paths

// Parallel next state computation
always @(*) begin
    case (current_state)
        A: begin w0_path = B; w1_path = A; end
        B: begin w0_path = C; w1_path = D; end
        C: begin w0_path = E; w1_path = D; end
        D: begin w0_path = F; w1_path = A; end
        E: begin w0_path = E; w1_path = D; end
        F: begin w0_path = C; w1_path = D; end
        default: begin w0_path = A; w1_path = A; end
    endcase
    
    next_state = w ? w1_path : w0_path;
end

// State register and output pipeline
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        z <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Registered output improves timing
        z <= (next_state == E) | (next_state == F);
    end
end

endmodule