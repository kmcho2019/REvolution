module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                nextState = 2'b01; // Stay in A if x is 0
                z = 1'b0;
            end else begin
                nextState = 2'b10; // Go to B if x is 1
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            if (x == 1'b0) begin
                nextState = 2'b10; // Stay in B if x is 0
                z = 1'b1;
            end else begin
                nextState = 2'b10; // Stay in B if x is 1
                z = 1'b0;
            end
        end
        default: begin
            nextState = 2'b01; // Default to A if state is unknown
            z = 1'b0;
        end
    endcase
end

endmodule