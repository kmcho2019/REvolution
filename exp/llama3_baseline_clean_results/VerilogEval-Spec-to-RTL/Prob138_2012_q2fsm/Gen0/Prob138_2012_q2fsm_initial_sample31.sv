module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define state codes
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Declare current state and next state signals
reg [2:0] currentState;
reg [2:0] nextState;

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

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Output z
always @(*) begin
    case (currentState)
        E, F: begin
            z = 1'b1;
        end
        default: begin
            z = 1'b0;
        end
    endcase
end

endmodule