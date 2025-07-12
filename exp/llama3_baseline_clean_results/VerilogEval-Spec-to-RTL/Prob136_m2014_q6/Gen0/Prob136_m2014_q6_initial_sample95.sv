module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

state_t current_state, next_state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always @(posedge clk) begin
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
        default: next_state <= A;
    endcase
end

// Output z logic
always @(current_state) begin
    case (current_state)
        A: z <= 0;
        B: z <= 0;
        C: z <= 0;
        D: z <= 0;
        E: z <= 1;
        F: z <= 1;
        default: z <= 0;
    endcase
end

endmodule