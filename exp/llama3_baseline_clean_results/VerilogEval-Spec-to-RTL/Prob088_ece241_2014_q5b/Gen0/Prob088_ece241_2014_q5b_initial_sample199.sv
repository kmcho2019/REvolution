module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // 2-bit register to store the current state
reg [1:0] nextState; // 2-bit register to store the next state

// One-hot encoding for the states
localparam A = 2'b01;
localparam B = 2'b10;

// Combinational logic block to generate the next state and output z
always @(*) begin
    case (state)
        A: begin
            if (~x) begin
                nextState = A;
                z = 1'b0;
            end else begin
                nextState = B;
                z = 1'b1;
            end
        end
        B: begin
            if (~x) begin
                nextState = B;
                z = 1'b1;
            end else begin
                nextState = B;
                z = 1'b0;
            end
        end
        default: begin
            nextState = A;
            z = 1'b0;
        end
    endcase
end

// Sequential logic to update the current state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

endmodule