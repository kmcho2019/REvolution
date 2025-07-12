module TopModule(
    input  clk,
    input  reset,
    input  w,
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
} curr_state, next_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        curr_state <= A;
    end else begin
        curr_state <= next_state;
    end
end

always_comb begin
    case (curr_state)
        A: begin
            if (~w) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (~w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        C: begin
            if (~w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (~w) begin
                next_state = F;
            end else begin
                next_state = A;
            end
        end
        E: begin
            if (w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        F: begin
            if (w) begin
                next_state = F;
            end else begin
                next_state = C;
            end
        end
        default: next_state = A;
    endcase
end

// Assign output z based on the current state
always_comb begin
    case (curr_state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule