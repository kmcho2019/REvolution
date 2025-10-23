module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State codes
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Continuous assignment statements for output g
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = (state == D);

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1) begin
                next_state = B;
            end else if (r[1] == 1) begin
                next_state = C;
            end else if (r[2] == 1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // There is no transition from D in the given state diagram.
            // Assuming it will go back to A when r2 becomes 0.
            if (r[2] == 1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A;
    endcase
end

endmodule