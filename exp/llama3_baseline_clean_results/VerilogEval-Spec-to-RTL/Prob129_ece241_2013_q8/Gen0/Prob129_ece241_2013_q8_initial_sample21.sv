module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2-bit register to represent the state
reg [1:0] nextState; // 2-bit register to represent the next state

localparam S0 = 2'b00; // State S0
localparam S1 = 2'b01; // State S1
localparam S2 = 2'b10; // State S2

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin // Asynchronous reset
        state <= S0;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                nextState = S1;
                z = 1'b0;
            end else begin
                nextState = S0;
                z = 1'b0;
            end
        end
        S1: begin
            if (~x) begin
                nextState = S2;
                z = 1'b0;
            end else begin
                nextState = S1;
                z = 1'b0;
            end
        end
        S2: begin
            if (x) begin
                nextState = S0;
                z = 1'b1;
            end else begin
                nextState = S2;
                z = 1'b0;
            end
        end
    endcase
end

endmodule