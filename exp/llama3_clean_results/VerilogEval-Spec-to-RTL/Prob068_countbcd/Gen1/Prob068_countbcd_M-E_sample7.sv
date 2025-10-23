module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// internal signals for each digit
wire [3:0] ones_q;
wire [3:0] tens_q;
wire [3:0] hundreds_q;
wire [3:0] thousands_q;

// internal enable signals
wire ones_ena;
wire tens_ena;
wire hundreds_ena;

// assign outputs
assign ena = {hundreds_ena, tens_ena, ones_ena};
assign q = {thousands_q, hundreds_q, tens_q, ones_q};

// enable signals
assign ones_ena = 1'b1;
assign tens_ena = ones_q == 4'd9;
assign hundreds_ena = tens_q == 4'd9;

// instantiate BCD counters
BCD_Counter ones_counter(
   .clk(clk),
   .reset(reset),
   .ena(ones_ena),
   .q(ones_q)
);

BCD_Counter tens_counter(
   .clk(clk),
   .reset(reset),
   .ena(tens_ena),
   .q(tens_q)
);

BCD_Counter hundreds_counter(
   .clk(clk),
   .reset(reset),
   .ena(hundreds_ena),
   .q(hundreds_q)
);

BCD_Counter thousands_counter(
   .clk(clk),
   .reset(reset),
   .ena(hundreds_q == 4'd9),
   .q(thousands_q)
);

endmodule