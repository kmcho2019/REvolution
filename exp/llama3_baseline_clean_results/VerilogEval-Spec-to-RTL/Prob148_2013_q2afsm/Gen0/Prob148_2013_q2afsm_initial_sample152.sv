module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state register
reg [1:0] state;
reg [1:0] next_state;

// Output assignments
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // g2 is never set to 1 according to the state diagram

// Next state logic
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1)
                next_state = B;
            else if (r[1] == 1'b1)
                next_state = C;
            else if (r[2] == 1'b1)
                next_state = A; // or we could use D if we had more logic for it
            else
                next_state = A;
        end
        B: begin
            if (r[0] == 1'b1)
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            if (r[1] == 1'b1)
                next_state = C;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule