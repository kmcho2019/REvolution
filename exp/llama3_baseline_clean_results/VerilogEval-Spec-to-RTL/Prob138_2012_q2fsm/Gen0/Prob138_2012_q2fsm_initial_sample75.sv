module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;  // Current state
reg [2:0] nextState;  // Next state

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= A;  // Reset to state A
    end else begin
        state <= nextState;  // Update current state
    end
end

always @(*) begin
    case (state)
        A: begin
            if (w) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (w) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        C: begin
            if (w) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        D: begin
            if (w) begin
                nextState = F;
            end else begin
                nextState = A;
            end
        end
        E: begin
            if (w) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        F: begin
            if (w) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        default: nextState = A;
    endcase
end

assign z = (state == E && w) || (state == F && w);  // Output z

endmodule