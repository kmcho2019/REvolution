module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Define current state and next state
reg [2:0] currentState;
reg [2:0] nextState;

// Define output
reg z;

always @(*) begin
    // Next state logic
    case (currentState)
        A: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        C: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        D: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = F;
            end
        end
        E: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        F: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to state A
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    // Output logic
    case (currentState)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule