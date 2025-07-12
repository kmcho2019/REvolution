module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the current and next states
reg [2:0] currentState;
reg [2:0] nextState;

// Implement the state flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Implement the state table
always @(*) begin
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
        default: nextState <= A;
    endcase
end

// Implement the output z
always @(*) begin
    case (currentState)
        A, B, C, D: z <= 0;
        E, F: z <= 1;
        default: z <= 0;
    endcase
end

endmodule