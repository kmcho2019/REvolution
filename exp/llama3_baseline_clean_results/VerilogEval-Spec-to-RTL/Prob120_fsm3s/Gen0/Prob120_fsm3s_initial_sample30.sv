module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define states as enumeration
enum logic [1:0] {A, B, C, D} state, next_state;

// Sequential logic for state transitions
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case(state)
        A: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        C: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 0;
        end
        D: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
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