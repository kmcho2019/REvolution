module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pipeline stage 1: Decode shift direction (registered)
reg shift_left_reg;
always @(posedge clk) begin
    shift_left_reg <= ~amount[1];
end

// Pipeline stage 2: Decode shift distance (registered)
reg shift_by_8_reg;
always @(posedge clk) begin
    shift_by_8_reg <= amount[0];
end

// Registered version of q for pipelining
reg [63:0] q_reg;
always @(posedge clk) begin
    q_reg <= q;
end

// Conditional shift computation
wire [63:0] shift_result;
assign shift_result = shift_left_reg ? 
    (shift_by_8_reg ? {q_reg[55:0], 8'b0} : {q_reg[62:0], 1'b0}) :
    (shift_by_8_reg ? $signed(q_reg) >>> 8 : $signed(q_reg) >>> 1);

// Next state logic with pipeline compensation
wire [63:0] next_q;
assign next_q = load ? data : 
               (ena ? (shift_left_reg || shift_by_8_reg ? shift_result : q_reg) : q);

// Main register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule