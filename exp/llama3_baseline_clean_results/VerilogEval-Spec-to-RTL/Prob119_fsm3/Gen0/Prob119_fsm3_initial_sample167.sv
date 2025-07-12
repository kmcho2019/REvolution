module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Always block for combinational logic
always @(*) begin
    case (state)
        A: begin
            next_state = (in) ? B : A;
            out = 0;
        end
        B: begin
            next_state = (in) ? B : C;
            out = 0;
        end
        C: begin
            next_state = (in) ? D : A;
            out = 0;
        end
        D: begin
            next_state = (in) ? B : C;
            out = 1;
        end
    endcase
end

endmodule