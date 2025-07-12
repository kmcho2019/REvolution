module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State encoding
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

reg [2:0] currentState, nextState;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always @ (*) begin
    case (currentState)
        A: begin
            if (w) begin
                nextState <= B;
            end else begin
                nextState <= A;
            end
        end
        B: begin
            if (w) begin
                nextState <= C;
            end else begin
                nextState <= D;
            end
        end
        C: begin
            if (w) begin
                nextState <= E;
            end else begin
                nextState <= D;
            end
        end
        D: begin
            if (w) begin
                nextState <= F;
            end else begin
                nextState <= A;
            end
        end
        E: begin
            if (w) begin
                nextState <= E;
            end else begin
                nextState <= D;
            end
        end
        F: begin
            if (w) begin
                nextState <= C;
            end else begin
                nextState <= D;
            end
        end
        default: begin
            nextState <= A;
        end
    endcase
end

// Output logic
assign z = (currentState == E) || (currentState == F);

endmodule