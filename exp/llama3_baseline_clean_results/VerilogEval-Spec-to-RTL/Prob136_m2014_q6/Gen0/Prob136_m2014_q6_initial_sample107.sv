module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101,
    F = 3'b110
} state_t;

// State register
reg [2:0] state;

// Initialize state
initial state = A;

// Update state and output
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= (w == 1'b0) ? B : A;
            B: state <= (w == 1'b0) ? C : D;
            C: state <= (w == 1'b0) ? E : D;
            D: state <= (w == 1'b0) ? F : A;
            E: state <= (w == 1'b0) ? E : D;
            F: state <= (w == 1'b0) ? C : D;
            default: state <= A; // This should not happen
        endcase
    end
end

// Update output
always @(*) begin
    case (state)
        A, B, C, D: z = 1'b0;
        E, F: z = (w == 1'b0) ? 1'b1 : 1'b1;
        default: z = 1'b0; // This should not happen
    endcase
end

endmodule