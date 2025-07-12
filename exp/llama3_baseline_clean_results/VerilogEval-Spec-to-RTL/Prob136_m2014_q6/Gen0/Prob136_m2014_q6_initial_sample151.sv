module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
typedef enum logic [3:0] {
    A = 4'd0,
    B = 4'd1,
    C = 4'd2,
    D = 4'd3,
    E = 4'd4,
    F = 4'd5
} state_type;

// Declare the current state
reg [3:0] current_state;

// Initialize the current state to A
initial current_state = A;

// Define the next state logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (!w) current_state <= B;
                else current_state <= A;
            end
            B: begin
                if (!w) current_state <= C;
                else current_state <= D;
            end
            C: begin
                if (!w) current_state <= E;
                else current_state <= D;
            end
            D: begin
                if (!w) current_state <= F;
                else current_state <= A;
            end
            E: begin
                if (w) current_state <= E;
                else current_state <= D;
            end
            F: begin
                if (w) current_state <= C;
                else current_state <= D;
            end
            default: current_state <= A;
        endcase
    end
end

// Define the output z
always @(*) begin
    case (current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule