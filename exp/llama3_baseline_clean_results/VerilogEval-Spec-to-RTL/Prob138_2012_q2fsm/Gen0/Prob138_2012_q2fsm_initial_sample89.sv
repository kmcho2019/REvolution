module TopModule(
    input        clk,
    input        reset,
    input        w,
    output       z
);

// Define states as enumeration values
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} current_state, next_state;

// State flip-flops
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always_comb begin
    case (current_state)
        A: begin
            if (w) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        C: begin
            if (w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (w) begin
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
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        default: next_state = A;
    endcase
end

// Output logic
assign z = (current_state == E || current_state == F);

endmodule