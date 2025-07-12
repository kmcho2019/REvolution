module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Correct tap mask for positions 32(31), 22(21), 2(1), 1(0)
localparam TAP_MASK = 32'b10000000001000000000000000000110;
wire [31:0] shifted_val;
wire feedback;

assign feedback = q[0];
assign shifted_val = {feedback, q[31:1]};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Apply XOR with feedback only to tap positions
        q <= shifted_val ^ (TAP_MASK & {32{feedback}});
    end
end

endmodule