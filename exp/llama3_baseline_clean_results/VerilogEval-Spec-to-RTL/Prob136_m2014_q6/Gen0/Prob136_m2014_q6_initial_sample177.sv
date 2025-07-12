module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} current_state, next_state;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Calculate the next state
always @(*) begin
    case (current_state)
        A: begin
            if (w) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= C;
            end
        end
        C: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= E;
            end
        end
        D: begin
            if (w) begin
                next_state <= A;
            end else begin
                next_state <= F;
            end
        end
        E: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= E;
            end
        end
        F: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= C;
            end
        end
        default: begin
            next_state <= A;
        end
    endcase
end

// Assign the output z based on the current state
assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;

endmodule