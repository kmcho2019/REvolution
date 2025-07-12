module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 3 states: S0 (2'b00), S1 (2'b01), S2 (2'b10)
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b00: begin // S0
            if (x) begin
                nextState = 2'b01; // Go to S1 if x is 1
            end else begin
                nextState = 2'b00; // Stay in S0 if x is 0
            end
            z = 1'b0;
        end
        2'b01: begin // S1
            if (~x) begin
                nextState = 2'b10; // Go to S2 if x is 0
            end else begin
                nextState = 2'b01; // Stay in S1 if x is 1
            end
            z = 1'b0;
        end
        2'b10: begin // S2
            if (x) begin
                nextState = 2'b01; // Go to S1 if x is 1, reset sequence
                z = 1'b1; // Assert z if sequence "101" is detected
            end else begin
                nextState = 2'b00; // Go to S0 if x is 0, reset sequence
                z = 1'b0;
            end
        end
        default: begin
            nextState = 2'b00;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00;
    end else begin
        state <= nextState;
    end
end

endmodule