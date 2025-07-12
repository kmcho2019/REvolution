module NextStateModule(
    input [2:0] y,
    input x,
    output reg [2:0] next_y
);

// Simplified state transition logic using a lookup table
reg [2:0] next_state_table [8];
always @(*) begin
    next_y = next_state_table[{y, x}];
end

initial begin
    next_state_table[0] = 3'b000; // 000, x=0
    next_state_table[1] = 3'b001; // 000, x=1
    next_state_table[2] = 3'b001; // 001, x=0
    next_state_table[3] = 3'b100; // 001, x=1
    next_state_table[4] = 3'b010; // 010, x=0
    next_state_table[5] = 3'b001; // 010, x=1
    next_state_table[6] = 3'b001; // 011, x=0
    next_state_table[7] = 3'b010; // 011, x=1
end

endmodule

module OutputModule(
    input [2:0] y,
    output reg z
);

// Simplified output logic using a lookup table
reg [0:0] output_table [8];
always @(*) begin
    z = output_table[y];
end

initial begin
    output_table[0] = 1'b0; // 000
    output_table[1] = 1'b0; // 001
    output_table[2] = 1'b0; // 010
    output_table[3] = 1'b1; // 011
    output_table[4] = 1'b1; // 100
    output_table[5] = 1'b0; // 101
    output_table[6] = 1'b0; // 110
    output_table[7] = 1'b0; // 111
end

endmodule

module PipelinedFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

NextStateModule next_state_module(
   .y(y),
   .x(x),
   .next_y(next_y)
);

OutputModule output_module(
   .y(y),
   .z(z)
);

// Sequential logic with clock gating
reg clock_enable;
always @(*) begin
    clock_enable = ~reset;
end

always @(posedge clk) begin
    if (clock_enable) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

PipelinedFSM pipelined_fsm(
    .clk(clk),
    .reset(reset),
    .x(x),
    .z(z)
);

endmodule