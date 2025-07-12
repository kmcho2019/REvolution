module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Current state register
reg [2:0] currentState;

// Initialize the current state to A
initial currentState = A;

// Determine the next state based on the current state and the input w
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        case (currentState)
            A: begin
                if (w) begin
                    currentState <= A;
                end else begin
                    currentState <= B;
                end
            end
            B: begin
                if (w) begin
                    currentState <= D;
                end else begin
                    currentState <= C;
                end
            end
            C: begin
                if (w) begin
                    currentState <= D;
                end else begin
                    currentState <= E;
                end
            end
            D: begin
                if (w) begin
                    currentState <= A;
                end else begin
                    currentState <= F;
                end
            end
            E: begin
                if (w) begin
                    currentState <= D;
                end else begin
                    currentState <= E;
                end
            end
            F: begin
                if (w) begin
                    currentState <= D;
                end else begin
                    currentState <= C;
                end
            end
            default: begin
                currentState <= A;
            end
        endcase
    end
end

// Determine the output z based on the current state
always @(currentState) begin
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