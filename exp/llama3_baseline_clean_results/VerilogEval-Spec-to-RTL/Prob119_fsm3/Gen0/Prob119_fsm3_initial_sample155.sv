module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Enumerate the states
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Always block for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Always block for combinational logic
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