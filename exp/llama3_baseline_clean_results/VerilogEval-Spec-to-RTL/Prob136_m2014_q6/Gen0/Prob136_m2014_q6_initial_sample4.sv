module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_type;

// Declare the current state
reg state_type current_state;

// Define the next state logic
always @(posedge clk) begin
    if (reset) begin
        // Reset the state to A
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (w) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= C;
                end
            end
            C: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= E;
                end
            end
            D: begin
                if (w) begin
                    current_state <= A;
                end else begin
                    current_state <= F;
                end
            end
            E: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= E;
                end
            end
            F: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= C;
                end
            end
            default: begin
                current_state <= A;
            end
        endcase
    end
end

// Define the output 'z' logic
always @(*) begin
    case (current_state)
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule