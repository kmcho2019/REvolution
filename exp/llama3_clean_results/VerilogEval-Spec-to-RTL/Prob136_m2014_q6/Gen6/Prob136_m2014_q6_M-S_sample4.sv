module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enumeration with fewer bits
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state;

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end else begin
        case (state)
            A: if (w == 1) begin state <= A; z <= 0; end else begin state <= B; z <= 0; end
            B: if (w == 1) begin state <= D; z <= 0; end else begin state <= C; z <= 0; end
            C: if (w == 1) begin state <= D; z <= 0; end else begin state <= E; z <= 0; end
            D: if (w == 1) begin state <= A; z <= 0; end else begin state <= F; z <= 0; end
            E: if (w == 1) begin state <= D; z <= 1; end else begin state <= E; z <= 1; end
            F: if (w == 1) begin state <= D; z <= 1; end else begin state <= C; z <= 1; end
            default: begin state <= A; z <= 0; end
        endcase
    end
end

endmodule