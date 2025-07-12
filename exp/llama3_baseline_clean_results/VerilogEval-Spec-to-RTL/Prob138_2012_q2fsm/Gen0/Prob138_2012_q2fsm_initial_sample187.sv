module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;
parameter E = 2'b00; // Overlapping with A due to simplicity and the nature of transitions
parameter F = 2'b01; // Overlapping with B due to simplicity and the nature of transitions

reg [1:0] currentState, nextState;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (currentState)
        A: if (w) begin
            nextState = B;
        end else begin
            nextState = A;
        end
        B: if (w) begin
            nextState = C;
        end else begin
            nextState = D;
        end
        C: if (w) begin
            nextState = E;
        end else begin
            nextState = D;
        end
        D: if (w) begin
            nextState = F;
        end else begin
            nextState = A;
        end
        E: if (w) begin
            nextState = E;
        end else begin
            nextState = D;
        end
        F: if (w) begin
            nextState = C;
        end else begin
            nextState = D;
        end
        default: nextState = A;
    endcase
end

// Output logic
assign z = (currentState == E || currentState == F) ? 1'b1 : 1'b0;

endmodule