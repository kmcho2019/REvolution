module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Current state register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always_comb begin
    case (state)
        A: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 0;
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = C;
            end
            out = 0;
        end
        C: begin
            if (in) begin
                next_state = D;
            end else begin
                next_state = A;
            end
            out = 0;
        end
        D: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = C;
            end
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

endmodule