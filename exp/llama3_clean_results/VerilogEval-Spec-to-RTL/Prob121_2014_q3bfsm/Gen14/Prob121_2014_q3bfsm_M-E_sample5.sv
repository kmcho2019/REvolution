module StateDecoder(
    input [2:0] y, // current state
    input x,
    output reg [2:0] next_y // next state
);

always @(*) begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

endmodule

module NextStateCalculator(
    input [2:0] next_y, // next state
    output reg [2:0] calculated_next_y // calculated next state
);

always @(*) begin
    calculated_next_y = next_y;
end

endmodule

module OutputGenerator(
    input [2:0] y, // current state
    output reg z // output
);

always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule

module StateRegister(
    input clk,
    input reset,
    input [2:0] next_y, // next state
    output reg [2:0] y // current state
);

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule

module HierarchicalFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

wire [2:0] next_y; // next state
wire [2:0] calculated_next_y; // calculated next state
reg [2:0] y; // current state

StateDecoder state_decoder(
    .y(y),
    .x(x),
    .next_y(next_y)
);

NextStateCalculator next_state_calculator(
    .next_y(next_y),
    .calculated_next_y(calculated_next_y)
);

OutputGenerator output_generator(
    .y(y),
    .z(z)
);

StateRegister state_register(
    .clk(clk),
    .reset(reset),
    .next_y(calculated_next_y),
    .y(y)
);

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

HierarchicalFSM hierarchical_fsm(
    .clk(clk),
    .reset(reset),
    .x(x),
    .z(z)
);

endmodule