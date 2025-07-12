module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define state codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Declare current state and next state variables
reg [2:0] currentState;
reg [2:0] nextState;

// Describe state flip-flops
always @ (posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Describe state table
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
            nextState <= A; // default state
        end
    endcase
end

// Describe output z
always @ (*) begin
    case (currentState)
        A: z <= 0;
        B: z <= 0;
        C: z <= 0;
        D: z <= 0;
        E: z <= 1;
        F: z <= 1;
        default: z <= 0; // default output
    endcase
end

endmodule