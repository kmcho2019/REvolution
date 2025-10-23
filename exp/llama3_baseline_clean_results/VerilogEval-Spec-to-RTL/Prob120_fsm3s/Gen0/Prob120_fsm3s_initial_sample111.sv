module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

enum logic [1:0] {A, B, C, D} current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case(current_state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
    endcase
end

always_comb begin
    case(current_state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule