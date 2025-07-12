module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      out
);

typedef enum {A, B} state_t;
state_t current_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        case (current_state)
            B: begin
                if (in == 0) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            A: begin
                if (in == 0) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: begin
                current_state <= B;
            end
        endcase
    end
end

always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule