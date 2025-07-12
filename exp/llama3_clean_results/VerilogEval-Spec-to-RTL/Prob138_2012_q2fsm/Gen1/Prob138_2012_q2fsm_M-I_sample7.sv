module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [5:0] currentState, nextState;

// Define states
localparam A = 6'b000001;
localparam B = 6'b000010;
localparam C = 6'b000100;
localparam D = 6'b001000;
localparam E = 6'b010000;
localparam F = 6'b100000;

// State flip-flops and output logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table and output logic
always @(*) begin
    case (currentState)
        A: begin
            if (w) begin
                nextState = B;
                z = w;
            end else begin
                nextState = A;
                z = w;
            end
        end
        B: begin
            if (w) begin
                nextState = C;
                z = w;
            end else begin
                nextState = D;
                z = w;
            end
        end
        C: begin
            if (w) begin
                nextState = E;
                z = w;
            end else begin
                nextState = D;
                z = w;
            end
        end
        D: begin
            if (w) begin
                nextState = F;
                z = w;
            end else begin
                nextState = A;
                z = w;
            end
        end
        E: begin
            if (w) begin
                nextState = E;
                z = w;
            end else begin
                nextState = D;
                z = w;
            end
        end
        F: begin
            if (w) begin
                nextState = C;
                z = w;
            end else begin
                nextState = D;
                z = w;
            end
        end
        default: begin
            nextState = A;
            z = w;
        end
    endcase
end

endmodule