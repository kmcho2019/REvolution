module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states of the machine
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Declare the current state and output
reg state_t current_state;
reg z;

// Initialize the current state and output
initial begin
    current_state = A;
    z = 1'b0;
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
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
        endcase
    end
end

// Combinational logic to determine the output 'z'
always @(*) begin
    case (current_state)
        A, B, C, D: z = 1'b0;
        E, F: z = 1'b1;
    endcase
end

endmodule