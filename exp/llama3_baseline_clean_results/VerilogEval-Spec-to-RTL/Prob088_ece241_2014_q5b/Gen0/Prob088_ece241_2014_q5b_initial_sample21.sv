module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state, next_state;
parameter A = 2'b01, B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @* begin
    case (current_state)
        A: begin
            if (x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = A;
                z = 1'b0;
            end
        end
        B: begin
            next_state = B; // Stay in B regardless of x
            z = ~x; // z is the inverse of x when in state B
        end
        default: begin
            next_state = A; // Default to state A if somehow we end up elsewhere
            z = 1'b0;
        end
    endcase
end

endmodule