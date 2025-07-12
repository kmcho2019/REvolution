module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] currentState;
reg [1:0] nextState;

// Initialize output
assign z = (currentState == 2'b10) | (currentState == 2'b01 && x == 1'b1);

// Next state logic
always @(currentState or x) begin
    case(currentState)
        2'b01: begin
            if(x == 1'b0)
                nextState = 2'b01;
            else
                nextState = 2'b10;
        end
        2'b10: begin
            nextState = 2'b10;
        end
        default: begin
            nextState = 2'b01;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        currentState <= 2'b01;
    end else begin
        currentState <= nextState;
    end
end

endmodule