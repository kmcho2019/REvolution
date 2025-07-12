`define STATE_WIDTH 3

enum logic [`STATE_WIDTH-1:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} State, NextState;

module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [`STATE_WIDTH-1:0] state_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= A;
    end else begin
        state_reg <= NextState;
    end
end

always_comb begin
    case (state_reg)
        A: begin
            if (!w) begin
                NextState = B;
            end else begin
                NextState = A;
            end
        end
        B: begin
            if (!w) begin
                NextState = C;
            end else begin
                NextState = D;
            end
        end
        C: begin
            if (!w) begin
                NextState = E;
            end else begin
                NextState = D;
            end
        end
        D: begin
            if (!w) begin
                NextState = F;
            end else begin
                NextState = A;
            end
        end
        E: begin
            if (!w) begin
                NextState = E;
            end else begin
                NextState = D;
            end
        end
        F: begin
            if (!w) begin
                NextState = C;
            end else begin
                NextState = D;
            end
        end
        default: NextState = A;
    endcase
end

assign z = (state_reg == E) | (state_reg == F);

endmodule