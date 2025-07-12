module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] nextState;

// One-hot encoding: A = 2'b10, B = 2'b01
localparam A = 2'b10;
localparam B = 2'b01;

always @(*) begin
    case(state)
        A: begin
            if(x == 0) begin
                nextState = A;
                z = 0;
            end else begin
                nextState = B;
                z = 1;
            end
        end
        B: begin
            if(x == 0) begin
                nextState = B;
                z = 1;
            end else begin
                nextState = B;
                z = 0;
            end
        end
        default: begin
            nextState = A; // Default next state
            z = 0; // Default output
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A; // Reset to state A
    end else begin
        state <= nextState;
    end
end

endmodule