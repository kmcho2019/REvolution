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
} currentState, nextState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Determine next state and output z
always @(*) begin
    case (currentState)
        A: begin
            z = 0;
            if (w) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            z = 0;
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        C: begin
            z = 0;
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        D: begin
            z = 0;
            if (w) begin
                nextState = A;
            end else begin
                nextState = F;
            end
        end
        E: begin
            z = 1;
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        F: begin
            z = 1;
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        default: begin
            z = 0;
            nextState = A;
        end
    endcase
end

endmodule