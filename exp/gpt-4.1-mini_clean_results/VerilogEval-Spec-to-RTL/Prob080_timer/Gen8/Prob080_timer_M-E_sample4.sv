module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

// Internal register for counter bits, only MSB stored in a flip-flop
reg msb_ff;
reg [8:0] counter_lower;  // Lower 9 bits are combinationally updated

wire [9:0] counter_next;
wire counter_is_zero;

// Next state logic:
// When load=1, load entire data;
// When load=0 and counter != 0, shift right by 1 with msb_ff updated;
// Else hold zero.

assign counter_next = load ? data : 
                      (|{msb_ff,counter_lower} ? {1'b0, msb_ff, counter_lower[8:1]} : 10'b0);

// Break next counter into MSB and lower 9 bits
wire next_msb = counter_next[9];
wire [8:0] next_lower = counter_next[8:0];

// Terminal count asserted when counter is zero
assign counter_is_zero = ~|{msb_ff, counter_lower};
assign tc = counter_is_zero;

// Sequential logic for the single flip-flop storing MSB bit
always @(posedge clk) begin
    msb_ff <= next_msb;
end

// Combinational logic updating lower 9 bits
always @(*) begin
    if (load)
        counter_lower = data[8:0];
    else if (!counter_is_zero)
        counter_lower = {msb_ff, counter_lower[8:1]};
    else
        counter_lower = 9'b0;
end

endmodule