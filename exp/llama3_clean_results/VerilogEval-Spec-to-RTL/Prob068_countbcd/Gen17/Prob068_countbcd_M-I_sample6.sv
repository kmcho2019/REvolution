// Optimized BCD Counter module with reduced transitions
module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output carry
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
        end else begin
            count <= count + 1'b1; // Using 1'b1 for increment to avoid synthesizing an adder
        end
    end
end

assign q = count;
assign carry = (count == 4'd9) && ena;

endmodule

// TopModule with optimized counters and enable logic
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

// internal carry signals
wire ones_carry;
wire tens_carry;
wire hundreds_carry;

// assign outputs
assign q = {thousands_q, hundreds_q, tens_q, ones_q};
assign ena = {hundreds_carry, tens_carry, ones_carry};

// instantiate BCD counters with optimized enable logic
BCD_Counter ones_counter(
 .clk(clk),
 .reset(reset),
 .ena(1'b1),
 .q(ones_q),
 .carry(ones_carry)
);

BCD_Counter tens_counter(
 .clk(clk),
 .reset(reset),
 .ena(ones_carry),
 .q(tens_q),
 .carry(tens_carry)
);

BCD_Counter hundreds_counter(
 .clk(clk),
 .reset(reset),
 .ena(tens_carry),
 .q(hundreds_q),
 .carry(hundreds_carry)
);

BCD_Counter thousands_counter(
 .clk(clk),
 .reset(reset),
 .ena(hundreds_carry),
 .q(thousands_q),
 .carry()
);

endmodule