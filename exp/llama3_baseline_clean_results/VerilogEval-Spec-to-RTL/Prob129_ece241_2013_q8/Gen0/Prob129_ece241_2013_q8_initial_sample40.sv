module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, nextState;

// 2-bit binary encoding for states
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
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
            end else begin
                nextState = S0;
            end
            z = 1'b0;
        end
        S1: begin
            if (x) begin
                nextState = S1;
            end else begin
                nextState = S2;
            end
            z = 1'b0;
        end
        S2: begin
            if (x) begin
                nextState = S1;
                z = 1'b1;
            end else begin
                nextState = S0;
                z = 1'b0;
            end
        end
        default: begin
            nextState = S0;
            z = 1'b0;
        end
    endcase
end

endmodule