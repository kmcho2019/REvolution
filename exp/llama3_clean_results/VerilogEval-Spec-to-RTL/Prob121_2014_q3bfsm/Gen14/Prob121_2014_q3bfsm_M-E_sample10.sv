module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state

// State modules
module State000(
    input clk,
    input reset,
    input x,
    output reg next_state,
    output reg z
);
reg next_state;
reg z;

always @(*) begin
    next_state = x? 3'b001 : 3'b000;
    z = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        next_state <= 3'b000;
        z <= 1'b0;
    end
end
endmodule

module State001(
    input clk,
    input reset,
    input x,
    output reg next_state,
    output reg z
);
reg next_state;
reg z;

always @(*) begin
    next_state = x? 3'b100 : 3'b001;
    z = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        next_state <= 3'b001;
        z <= 1'b0;
    end
end
endmodule

module State010(
    input clk,
    input reset,
    input x,
    output reg next_state,
    output reg z
);
reg next_state;
reg z;

always @(*) begin
    next_state = x? 3'b001 : 3'b010;
    z = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        next_state <= 3'b010;
        z <= 1'b0;
    end
end
endmodule

module State011(
    input clk,
    input reset,
    input x,
    output reg next_state,
    output reg z
);
reg next_state;
reg z;

always @(*) begin
    next_state = x? 3'b010 : 3'b001;
    z = 1'b1;
end

always @(posedge clk) begin
    if (reset) begin
        next_state <= 3'b011;
        z <= 1'b1;
    end
end
endmodule

module State100(
    input clk,
    input reset,
    input x,
    output reg next_state,
    output reg z
);
reg next_state;
reg z;

always @(*) begin
    next_state = x? 3'b100 : 3'b011;
    z = 1'b1;
end

always @(posedge clk) begin
    if (reset) begin
        next_state <= 3'b100;
        z <= 1'b1;
    end
end
endmodule

// State module instantiation
State000 state000(
   .clk(clk),
   .reset(reset),
   .x(x),
   .next_state(),
   .z()
);

State001 state001(
   .clk(clk),
   .reset(reset),
   .x(x),
   .next_state(),
   .z()
);

State010 state010(
   .clk(clk),
   .reset(reset),
   .x(x),
   .next_state(),
   .z()
);

State011 state011(
   .clk(clk),
   .reset(reset),
   .x(x),
   .next_state(),
   .z()
);

State100 state100(
   .clk(clk),
   .reset(reset),
   .x(x),
   .next_state(),
   .z()
);

// State decoding and transition logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: y <= state000.next_state;
            3'b001: y <= state001.next_state;
            3'b010: y <= state010.next_state;
            3'b011: y <= state011.next_state;
            3'b100: y <= state100.next_state;
            default: y <= 3'b000;
        endcase
    end
end

// Output generation
assign z = (y == 3'b011) || (y == 3'b100);

endmodule