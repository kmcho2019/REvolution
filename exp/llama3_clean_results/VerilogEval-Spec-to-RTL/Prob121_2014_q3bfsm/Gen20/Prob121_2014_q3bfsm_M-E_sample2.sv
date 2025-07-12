module DistributedFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states
reg [2:0] state;

// Define the next state logic
always @(*) begin
    case (state)
        3'b000: state = (x == 0)? 3'b000 : 3'b001;
'b001: state = (x == 0)? 3'b001 : 3'b100;
        3'b010: state = (x == 0)? 3'b010 : 3'b001;
        3'b011: state = (x == 0)? 3'b001 : 3'b010;
        3'b100: state = (x == 0)? 3'b011 : 3'b100;
        default: state = (x == 0)? 3'b000 : 3'b001;
    endcase
end

// Define the output logic
always @(*) begin
    case (state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Define the clock gating logic
reg clock_enable;
always @(*) begin
    case (state)
        3'b000: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b001: clock_enable = (x == 0)? 1'b0 : 1'b1;
'b010: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b011: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b100: clock_enable = (x == 0)? 1'b0 : 1'b1;
        default: clock_enable = 1'b0;
    endcase
end

// Define the voltage scaling logic
reg voltage_enable;
always @(*) begin
    case (state)
        3'b000: voltage_enable = (x == 0)? 1'b0 : 1'b1;
'b001: voltage_enable = (x == 0)? 1'b0 : 1'b1;
        3'b010: voltage_enable = (x == 0)? 1'b0 : 1'b1;
        3'b011: voltage_enable = (x == 0)? 1'b0 : 1'b1;
'b100: voltage_enable = (x == 0)? 1'b0 : 1'b1;
        default: voltage_enable = 1'b0;
    endcase
end

// Define the sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // synchronous active high reset
    end else if (clock_enable) begin
        state <= state; // hold the current state
    end else begin
        state <= state; // hold the current state
    end
end

endmodule