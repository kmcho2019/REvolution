module DeltaEncodingFSM(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg [2:0] delta; // delta value

// State decoding stage
always @(*) begin
    case (y)
        3'b000: delta = x? 3'b001 : 3'b000;
        3'b001: delta = x? 3'b100 : 3'b001;
        3'b010: delta = x? 3'b001 : 3'b010;
        3'b011: delta = x? 3'b010 : 3'b001;
        3'b100: delta = x? 3'b100 : 3'b011;
        default: delta = 3'b000;
    endcase
end

// Delta computation stage
always @(*) begin
    next_y = y + delta;
end

// Output generation stage
always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

DeltaEncodingFSM delta_encoding_fsm(
   .clk(clk),
   .reset(reset),
   .x(x),
   .z(z)
);

endmodule