module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

typedef enum logic [0:0] {A, B} state_type;
state_type state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        A: begin
            if (in == 1'b0) begin
                next_state = B;
                out = 1'b0;
            end else begin
                next_state = A;
                out = 1'b0;
            end
        end
        B: begin
            if (in == 1'b0) begin
                next_state = A;
                out = 1'b1;
            end else begin
                next_state = B;
                out = 1'b1;
            end
        end
        default: begin
            next_state = B;
            out = 1'b1;
        end
    endcase
end

endmodule