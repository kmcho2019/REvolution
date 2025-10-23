module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states and transitions
wire [2:0] s000;
wire [2:0] s001;
wire [2:0] s010;
wire [2:0] s011;
wire [2:0] s100;

// Define the token-passing signals
wire token_s000_to_s001;
wire token_s001_to_s100;
wire token_s010_to_s001;
wire token_s011_to_s010;
wire token_s100_to_s011;

// Module for state 000
module State000(
    input x,
    input reset,
    output reg [2:0] s000,
    output reg token_s000_to_s001
);
always @(posedge clk) begin
    if (reset) begin
        s000 <= 3'b000;
        token_s000_to_s001 <= 1'b0;
    end else if (x) begin
        s000 <= 3'b001;
        token_s000_to_s001 <= 1'b1;
    end else begin
        s000 <= 3'b000;
        token_s000_to_s001 <= 1'b0;
    end
end
endmodule

// Module for state 001
module State001(
    input x,
    input token_s000_to_s001,
    input token_s010_to_s001,
    output reg [2:0] s001,
    output reg token_s001_to_s100
);
always @(posedge clk) begin
    if (reset) begin
        s001 <= 3'b000;
        token_s001_to_s100 <= 1'b0;
    end else if (token_s000_to_s001 || token_s010_to_s001) begin
        s001 <= 3'b001;
        token_s001_to_s100 <= x;
    end else begin
        s001 <= 3'b000;
        token_s001_to_s100 <= 1'b0;
    end
end
endmodule

// Module for state 010
module State010(
    input x,
    input token_s011_to_s010,
    output reg [2:0] s010,
    output reg token_s010_to_s001
);
always @(posedge clk) begin
    if (reset) begin
        s010 <= 3'b000;
        token_s010_to_s001 <= 1'b0;
    end else if (token_s011_to_s010) begin
        s010 <= 3'b010;
        token_s010_to_s001 <= x;
    end else begin
        s010 <= 3'b000;
        token_s010_to_s001 <= 1'b0;
    end
end
endmodule

// Module for state 011
module State011(
    input x,
    input token_s001_to_s011,
    output reg [2:0] s011,
    output reg token_s011_to_s010,
    output reg z
);
always @(posedge clk) begin
    if (reset) begin
        s011 <= 3'b000;
        token_s011_to_s010 <= 1'b0;
        z <= 1'b0;
    end else if (token_s001_to_s011) begin
        s011 <= 3'b011;
        token_s011_to_s010 <= x;
        z <= 1'b1;
    end else begin
        s011 <= 3'b000;
        token_s011_to_s010 <= 1'b0;
        z <= 1'b0;
    end
end
endmodule

// Module for state 100
module State100(
    input x,
    input token_s001_to_s100,
    output reg [2:0] s100,
    output reg token_s100_to_s011
);
always @(posedge clk) begin
    if (reset) begin
        s100 <= 3'b000;
        token_s100_to_s011 <= 1'b0;
    end else if (token_s001_to_s100) begin
        s100 <= 3'b100;
        token_s100_to_s011 <= x;
    end else begin
        s100 <= 3'b000;
        token_s100_to_s011 <= 1'b0;
    end
end
endmodule

// Instantiate the modules
State000 state000(
    .x(x),
    .reset(reset),
    .s000(s000),
    .token_s000_to_s001(token_s000_to_s001)
);

State001 state001(
    .x(x),
    .token_s000_to_s001(token_s000_to_s001),
    .token_s010_to_s001(token_s010_to_s001),
    .s001(s001),
    .token_s001_to_s100(token_s001_to_s100)
);

State010 state010(
    .x(x),
    .token_s011_to_s010(token_s011_to_s010),
    .s010(s010),
    .token_s010_to_s001(token_s010_to_s001)
);

State011 state011(
    .x(x),
    .token_s001_to_s011(token_s001_to_s100),
    .s011(s011),
    .token_s011_to_s010(token_s011_to_s010),
    .z(z)
);

State100 state100(
    .x(x),
    .token_s001_to_s100(token_s001_to_s100),
    .s100(s100),
    .token_s100_to_s011(token_s100_to_s011)
);

endmodule