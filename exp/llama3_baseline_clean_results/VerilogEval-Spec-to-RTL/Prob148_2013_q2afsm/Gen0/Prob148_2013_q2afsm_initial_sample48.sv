module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] currentState, nextState;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case (currentState)
        A: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else if (r[1] == 1'b1) begin
                nextState = C;
            end else if (r[2] == 1'b1) begin
                nextState = D;
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
        D: begin
            // Since D is not explicitly mentioned in the state diagram,
            // we'll assume it behaves like the other grant states
            if (r[2] == 1'b1) begin
                nextState = D;
            end else begin
                nextState = A;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// Output logic
always @(*) begin
    case (currentState)
        A: begin
            g = 3'b000;
        end
        B: begin
            g = 3'b100;
        end
        C: begin
            g = 3'b010;
        end
        D: begin
            g = 3'b001;
        end
        default: begin
            g = 3'b000;
        end
    endcase
end

endmodule