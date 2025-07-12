module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

reg [2:0] currentState, nextState;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case (currentState)
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

// Output logic
assign z = ((currentState == E || currentState == F) && w) ? 1'b1 : 1'b0;

endmodule