module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

parameter A = 3'b000, B = 3'b001, C = 3'b010;

reg [2:0] state;
reg [2:0] nextState;

// State Flip-Flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// State Table
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else if (r[1] == 1'b1) begin
                nextState = C;
            end else if (r[2] == 1'b1) begin
                // We can keep the state as A since device 2 has the lowest priority
                nextState = A;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                nextState = C;
            end else begin
                nextState = A;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// Output Logic
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since state D is not reachable, we can set g[2] to 0

endmodule