module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // State register with one-hot encoding
reg [1:0] nextState; // Next state register

// One-hot encoding for states
localparam A = 2'b01;
localparam B = 2'b10;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        A: begin
            if (x == 0) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (x == 0) begin
                nextState = B;
            end else begin
                nextState = B;
            end
        end
        default: begin
            nextState = A; // Default to state A
        end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Reset to state A on asynchronous reset
    end else begin
        state <= nextState;
    end
end

// Combinational logic to determine the output z
always @(*) begin
    case (state)
        A: begin
            if (x == 0) begin
                z = 0;
            end else begin
                z = 1;
            end
        end
        B: begin
            if (x == 0) begin
                z = 1;
            end else begin
                z = 0;
            end
        end
        default: begin
            z = 0; // Default output
        end
    endcase
end

endmodule