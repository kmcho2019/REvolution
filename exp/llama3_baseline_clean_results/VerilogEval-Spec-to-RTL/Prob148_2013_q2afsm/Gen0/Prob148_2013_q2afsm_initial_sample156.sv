module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State codes
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Next state logic
always @(*) begin
    case(state)
        A: 
            if(r[0] == 1'b1) begin
                next_state = B;
            end else if(r[1] == 1'b1) begin
                next_state = C;
            end else if(r[2] == 1'b1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        B: 
            if(r[0] == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        C: 
            if(r[1] == 1'b1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        D: 
            // This state is actually unreachable based on the given state diagram
            // But we will still include it for completeness
            next_state = A;
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if(~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since there is no output g2 in the state diagram

endmodule