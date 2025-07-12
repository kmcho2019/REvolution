module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 1-bit variable to represent states A and B
localparam A = 1'b0; // State A
localparam B = 1'b1; // State B

always @(posedge clk) begin
    if(reset) begin // Active-high synchronous reset
        state <= B; // Go to state B when reset is high
    end else begin
        case(state)
            B: begin
                if(!in) begin
                    state <= A; // Transition from B to A when in=0
                end else begin
                    state <= B; // Stay in B when in=1
                end
            end
            A: begin
                if(!in) begin
                    state <= B; // Transition from A to B when in=0
                end else begin
                    state <= A; // Stay in A when in=1
                end
            end
        endcase
    end
end

always @(*) begin
    case(state)
        B: out = 1'b1; // Output is 1 when in state B
        A: out = 1'b0; // Output is 0 when in state A
    endcase
end

endmodule