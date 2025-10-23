module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

// Initialize the current state
reg [1:0] currentState;

// Implement the state machine
always @(posedge clk) begin
    if (reset) begin
        // Reset to state A
        currentState <= A;
        out <= 0;
    end else begin
        // Update the current state
        case (currentState)
            A: begin
                if (in) begin
                    currentState <= B;
                end else begin
                    currentState <= A;
                end
            end
            B: begin
                if (in) begin
                    currentState <= B;
                end else begin
                    currentState <= C;
                end
            end
            C: begin
                if (in) begin
                    currentState <= D;
                end else begin
                    currentState <= A;
                end
            end
            D: begin
                if (in) begin
                    currentState <= B;
                end else begin
                    currentState <= C;
                end
            end
            default: begin
                currentState <= A;
            end
        endcase
        
        // Update the output
        case (currentState)
            A: out <= 0;
            B: out <= 0;
            C: out <= 0;
            D: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule