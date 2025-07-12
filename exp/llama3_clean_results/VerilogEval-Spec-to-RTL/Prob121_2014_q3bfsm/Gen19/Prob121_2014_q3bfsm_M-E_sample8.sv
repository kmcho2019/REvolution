module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// StateDecoder module
module StateDecoder(
    input [2:0] y,
    input x,
    output reg [2:0] next_y
);
    always @(*) begin
        case (y)
            3'b000: next_y = x? 3'b001 : 3'b000;
            3'b001: next_y = x? 3'b100 : 3'b001;
            3'b010: next_y = x? 3'b001 : 3'b010;
            3'b011: next_y = x? 3'b010 : 3'b001;
            3'b100: next_y = x? 3'b100 : 3'b011;
            default: next_y = 3'b000;
        endcase
    end
endmodule

// NextStateLogic module
module NextStateLogic(
    input [2:0] y,
    input x,
    output reg clk_en
);
    always @(*) begin
        case (y)
            3'b000: clk_en = x? 1'b1 : 1'b0;
            3'b001: clk_en = x? 1'b1 : 1'b0;
            3'b010: clk_en = x? 1'b1 : 1'b0;
            3'b011: clk_en = x? 1'b1 : 1'b0;
            3'b100: clk_en = x? 1'b1 : 1'b0;
            default: clk_en = 1'b0;
        endcase
    end
endmodule

// OutputGenerator module
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

// Instantiate sub-modules
StateDecoder state_decoder(
   .y(y),
   .x(x),
   .next_y(next_y)
);

NextStateLogic next_state_logic(
   .y(y),
   .x(x),
   .clk_en(clk_en)
);

OutputGenerator output_generator(
   .y(y),
   .z(z)
);

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else if (clk_en) begin
        y <= next_y;
    end
end

endmodule