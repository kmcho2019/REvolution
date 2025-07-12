module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// State register
reg [1:0] state;
reg [1:0] nextState;

// Output g based on current state
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // Since there is no state where g[2] = 1

// Next state logic
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else if (r[1] == 1'b1) begin
                nextState = C;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (r[0] == 1'b0) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        C: begin
            if (r[1] == 1'b0) begin
                nextState = A;
            end else begin
                nextState = C;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

endmodule