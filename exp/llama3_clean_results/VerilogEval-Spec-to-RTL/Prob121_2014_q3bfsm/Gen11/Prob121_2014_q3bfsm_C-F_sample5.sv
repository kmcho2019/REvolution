module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

reg [2:0] state;
reg [2:0] next_state;

// Define the next state logic
always @(*) begin
    case (state)
        S000: next_state = x ? S001 : S000;
        S001: next_state = x ? S100 : S001;
        S010: next_state = x ? S001 : S010;
        S011: next_state = x ? S010 : S001;
        S100: next_state = x ? S100 : S011;
        default: next_state = S000;
    endcase
end

// Define the output logic
always @(*) begin
    case (state)
        S011: z = 1'b1;
        S100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= S000;
    end else begin
        state <= next_state;
    end
end

// Clock gating to reduce power consumption
reg clock_enable;
always @(*) begin
    clock_enable = (state != next_state) || reset;
end

// Use the clock_enable signal to gate the clock
wire gated_clk;
assign gated_clk = clock_enable ? clk : 1'b0;

// Replace the clk signal with the gated_clk signal
// Note: In this simplified example, we don't actually need to use the gated_clk signal,
// as the clock gating is implicitly handled by the always block.
// However, in a real design, you would use the gated_clk signal as the clock input to your sequential logic.

endmodule