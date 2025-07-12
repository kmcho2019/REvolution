module TopModule(
    input         clk,
    input         reset,
    input         in,
    output        out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Synchronous logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 1'b0;
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1'b0;
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 1'b0;
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1'b1;
        end
        default: begin
            next_state = A;
            out = 1'b0;
        end
    endcase
end

endmodule