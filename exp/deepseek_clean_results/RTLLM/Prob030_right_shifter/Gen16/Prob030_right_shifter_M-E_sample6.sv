module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

// Pipeline stage 1 (upper 4 bits)
reg [3:0] upper_stage;
wire upper_overflow = upper_stage[0];

always @(posedge clk) begin
    upper_stage <= {d, upper_stage[3:1]};
end

// Pipeline stage 2 (lower 4 bits)
reg [3:0] lower_stage;

always @(posedge clk) begin
    lower_stage <= {upper_overflow, lower_stage[3:1]};
end

// Output concatenation
assign q = {upper_stage, lower_stage};

// Initialization
initial begin
    upper_stage = 4'b0;
    lower_stage = 4'b0;
end

endmodule