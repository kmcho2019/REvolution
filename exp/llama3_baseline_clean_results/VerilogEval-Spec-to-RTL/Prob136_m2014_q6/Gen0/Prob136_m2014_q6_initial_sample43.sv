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
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case(state)
        A: begin
            if(w) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if(w) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if(w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        default: next_state = A;
    endcase
end

// Output logic
always_comb begin
    case(state)
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