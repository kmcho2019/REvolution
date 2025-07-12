module StateDecoder(
    input [2:0] y,
    output reg [7:0] one_hot_y
);

always @(*) begin
    case (y)
        3'b000: one_hot_y = 8'b00000001;
        3'b001: one_hot_y = 8'b00000010;
        3'b010: one_hot_y = 8'b00000100;
        3'b011: one_hot_y = 8'b00001000;
        3'b100: one_hot_y = 8'b00010000;
        default: one_hot_y = 8'b00000000;
    endcase
end

endmodule

module TransitionController(
    input [7:0] one_hot_y,
    input x,
    output reg [2:0] next_y
);

always @(*) begin
    if (one_hot_y[0]) begin // 000
        next_y = x? 3'b001 : 3'b000;
    end else if (one_hot_y[1]) begin // 001
        next_y = x? 3'b100 : 3'b001;
    end else if (one_hot_y[2]) begin // 010
        next_y = x? 3'b001 : 3'b010;
    end else if (one_hot_y[3]) begin // 011
        next_y = x? 3'b010 : 3'b001;
    end else if (one_hot_y[4]) begin // 100
        next_y = x? 3'b100 : 3'b011;
    end else begin
        next_y = 3'b000;
    end
end

endmodule

module OutputGenerator(
    input [2:0] y,
    output reg z
);

always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg [7:0] one_hot_y;

StateDecoder state_decoder(
  .y(y),
  .one_hot_y(one_hot_y)
);

TransitionController transition_controller(
  .one_hot_y(one_hot_y),
  .x(x),
  .next_y(next_y)
);

OutputGenerator output_generator(
  .y(y),
  .z(z)
);

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule