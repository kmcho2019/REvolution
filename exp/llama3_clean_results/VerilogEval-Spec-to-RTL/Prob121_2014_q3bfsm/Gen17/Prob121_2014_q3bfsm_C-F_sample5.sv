module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the next state logic using a case statement
reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case (state)
        3'b000: next_state = x? 3'b001 : 3'b000;
        3'b001: next_state = x? 3'b100 : 3'b001;
        3'b010: next_state = x? 3'b001 : 3'b010;
        3'b011: next_state = x? 3'b010 : 3'b001;
        3'b100: next_state = x? 3'b100 : 3'b011;
        default: next_state = 3'b000;
    endcase
end

// Define the output logic using a case statement
always @(*) begin
    case (state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

// Apply clock gating to reduce power consumption
reg clk_gate;
always @(*) begin
    clk_gate = (state!= 3'b000) || x;
end

// Use the gated clock to update the state
always @(posedge clk_gate) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

endmodule