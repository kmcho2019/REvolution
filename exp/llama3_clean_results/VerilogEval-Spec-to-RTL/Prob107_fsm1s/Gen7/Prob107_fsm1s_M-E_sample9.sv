module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Using 2-bit one-hot encoding for the states

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b01; // Reset state is B, represented by one-hot '01'
    end else begin
        case(state)
            2'b01: state <= in ? 2'b01 : 2'b10; // State B, transition to A if in=0
            2'b10: state <= in ? 2'b10 : 2'b01; // State A, transition to B if in=0
            default: state <= 2'b01; // Default state is B
        endcase
    end
end

assign out = ~state[1]; // Output is 1 in state B (01) and 0 in state A (10)

endmodule