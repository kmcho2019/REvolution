module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
reg [0:0] state; // 1-bit state register
localparam S0 = 1'b0; // State S0 (q=0)
localparam S1 = 1'b1; // State S1 (q=1)

// Initialize state
initial state = S1;

// State transition logic
always @(posedge clk) begin
    case(state)
        S0: if (a) state <= S1; // Transition from S0 to S1 when a=1
        S1: if (!a) state <= S0; // Transition from S1 to S0 when a=0
        default: state <= S1; // Default state
    endcase
end

// Output logic
assign q = (state == S1) ? 1'b1 : 1'b0;

endmodule