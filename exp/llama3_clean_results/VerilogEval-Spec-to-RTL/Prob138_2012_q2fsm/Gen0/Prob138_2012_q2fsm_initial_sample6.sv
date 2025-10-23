module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState, nextState;

// Define states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

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
        default: begin
            nextState = A;
        end
    endcase
end

// Output logic
assign z = w;

endmodule