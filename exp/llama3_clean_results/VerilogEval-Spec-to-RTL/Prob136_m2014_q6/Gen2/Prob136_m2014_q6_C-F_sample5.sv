module TopModule(
    input clk,
    input reset,
    input w,
    output logic z
);

// Define the states using one-hot encoding
enum logic [:0] {
    A = 6'b000001,
    B = 6'b000010,
    C = 6'b000100,
    D = 6'b001000,
    E = 6'b010000,
    F = 6'b100000
} state, next_state;

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine next state
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

// Determine output z
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