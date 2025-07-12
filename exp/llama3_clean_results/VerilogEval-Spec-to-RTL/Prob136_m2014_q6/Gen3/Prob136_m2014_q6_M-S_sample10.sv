module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state;

// State transition and output z logic
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= w? A : B;
            B: state <= w? D : C;
            C: state <= w? D : E;
            D: state <= w? A : F;
            E: state <= w? D : E;
            F: state <= w? D : C;
            default: state <= A;
        endcase
    end
    // Assign output z based on the current state
    z = (state == E) || (state == F);
end

endmodule