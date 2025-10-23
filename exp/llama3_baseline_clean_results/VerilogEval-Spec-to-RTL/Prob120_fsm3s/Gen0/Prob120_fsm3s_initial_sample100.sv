module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        A: begin
            if (in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 1'b0;
        end
        B: begin
            if (in == 1'b0) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1'b0;
        end
        C: begin
            if (in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 1'b0;
        end
        D: begin
            if (in == 1'b0) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1'b1;
        end
    endcase
end

endmodule