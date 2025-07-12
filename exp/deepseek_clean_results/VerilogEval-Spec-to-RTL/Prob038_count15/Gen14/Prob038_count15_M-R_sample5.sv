module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// LFSR-style lower bits (0-1)
assign next_count[0] = ~count[0];
assign next_count[1] = count[0] ? ~count[1] : count[1];

// Arithmetic upper bits (2-3)
wire [1:0] upper_inc = count[1:0] == 2'b11 ? (count[3:2] + 1'b1) : count[3:2];
assign next_count[3:2] = upper_inc;

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        count <= next_count;
    end
end

assign q = count;

endmodule