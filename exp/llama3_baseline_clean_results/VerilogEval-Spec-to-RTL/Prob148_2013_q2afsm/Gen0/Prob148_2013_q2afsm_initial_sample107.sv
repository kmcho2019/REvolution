module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011; // will be treated as A

// State register
reg [2:0] state;
reg [2:0] nextState;

// Continuous assignment for outputs
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // Since in the state diagram, there's no state that sets g[2] to 1

// Next state logic
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else if (r[1] == 1'b1) begin
                nextState = C;
            end else if (r[2] == 1'b1) begin
                nextState = A; // This will treat D as A
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
        default: begin // includes D
            nextState = A;
        end
    endcase
end

// State flip-flop
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

endmodule