module TopModule(
    input  clk,
    input  areset,
    input  in,
    output logic out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// State machine
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (~in) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end
            B: begin
                if (~in) begin
                    next_state <= C;
                end else begin
                    next_state <= B;
                end
            end
            C: begin
                if (~in) begin
                    next_state <= A;
                end else begin
                    next_state <= D;
                end
            end
            D: begin
                if (~in) begin
                    next_state <= C;
                end else begin
                    next_state <= B;
                end
            end
            default: next_state <= A;
        endcase
        current_state <= next_state;
    end
end

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule