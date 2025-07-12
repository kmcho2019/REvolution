module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count_reg;
wire [3:0] next_count;
wire gated_clk;

// Clock gating when counter reaches max value
assign gated_clk = (count_reg == 4'b1111) ? 1'b0 : clk;

// Ripple-carry increment logic (optimized for +1 operation)
assign next_count[0] = ~count_reg[0];
assign next_count[1] = count_reg[1] ^ count_reg[0];
assign next_count[2] = count_reg[2] ^ (&count_reg[1:0]);
assign next_count[3] = count_reg[3] ^ (&count_reg[2:0]);

// Sequential state update with synchronous reset
always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        count_reg <= 4'b0000;
    end else begin
        count_reg <= next_count;
    end
end

// Output assignment
assign q = count_reg;

endmodule