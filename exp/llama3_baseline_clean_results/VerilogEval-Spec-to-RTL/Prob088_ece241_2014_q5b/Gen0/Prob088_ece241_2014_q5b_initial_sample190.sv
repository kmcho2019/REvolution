module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// One-hot encoding for states
reg [1:0] currentState;
reg [1:0] nextState;

// Define states
localparam A = 2'b01;
localparam B = 2'b10;

// Combinational logic for next state and output
always @(*) begin
    case(currentState)
        A: begin
            if (!x) begin
                nextState = A;
                z = 0;
            end else begin
                nextState = B;
                z = 1;
            end
        end
        B: begin
            if (!x) begin
                nextState = B;
                z = 1;
            end else begin
                nextState = B;
                z = 0;
            end
        end
        default: begin
            nextState = A;
            z = 0;
        end
    endcase
end

// Sequential logic for state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule