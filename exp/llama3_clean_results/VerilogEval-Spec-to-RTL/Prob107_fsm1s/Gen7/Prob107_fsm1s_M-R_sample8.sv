module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // 2-state variable
localparam B = 2'b01; // State B
localparam A = 2'b10; // State A

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= B; // Reset to state B
    end else begin
        case(state)
            B: state <= in ? B : A; // Transition from B to A or B
            A: state <= in ? A : B; // Transition from A to B or A
        endcase
    end
end

assign out = state == B; // Output is 1 when in state B

endmodule