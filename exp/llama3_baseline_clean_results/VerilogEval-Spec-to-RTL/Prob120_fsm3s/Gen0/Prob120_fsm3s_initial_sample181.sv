module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states as parameters for better readability
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Declare the current state variable
reg [1:0] currentState;

// Initialize the output
reg out;

// Always block for sequential logic
always @(posedge clk) begin
    if (reset) begin // Active high reset
        currentState <= A; // Reset to state A
    end else begin
        case (currentState)
            A: begin
                if (!in) begin
                    currentState <= A;
                end else begin
                    currentState <= B;
                end
            end
            B: begin
                if (!in) begin
                    currentState <= C;
                end else begin
                    currentState <= B;
                end
            end
            C: begin
                if (!in) begin
                    currentState <= A;
                end else begin
                    currentState <= D;
                end
            end
            D: begin
                if (!in) begin
                    currentState <= C;
                end else begin
                    currentState <= B;
                end
            end
        endcase
    end
end

// Combinational logic for output
always @(*) begin
    case (currentState)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule