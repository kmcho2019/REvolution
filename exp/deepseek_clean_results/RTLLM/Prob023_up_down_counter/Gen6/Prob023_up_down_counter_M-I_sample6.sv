module up_down_counter (
    input clk,
    input reset,
    input up_down,
    input enable,      // Added enable signal for power optimization
    output [15:0] count
);

reg [15:0] count_reg;
wire [15:0] next_count;
wire gated_clk;

// Clock gating for power optimization
assign gated_clk = clk & (enable | reset);

// Gray code conversion for power optimization
wire [15:0] gray_count;
assign gray_count = count_reg ^ (count_reg >> 1);

// Carry-select adder implementation (4-bit segments)
wire [3:0] count_lsb, count_msb1, count_msb2, count_msb3;
wire carry0, carry1, carry2;

// LSB 4-bit counter
assign {carry0, count_lsb} = up_down ? 
                            (count_reg[3:0] + 1'b1) : 
                            (count_reg[3:0] - 1'b1);

// Middle 4-bit counters with registered carries
always @(posedge gated_clk) begin
    if (reset) begin
        count_msb1 <= 4'b0;
        count_msb2 <= 4'b0;
        count_msb3 <= 4'b0;
        count_reg[15:12] <= 4'b0;
    end else if (enable) begin
        // MSB1 counter
        if (carry0) begin
            {carry1, count_msb1} <= up_down ? 
                                  (count_reg[7:4] + 1'b1) : 
                                  (count_reg[7:4] - 1'b1);
        end
        
        // MSB2 counter
        if (carry1) begin
            {carry2, count_msb2} <= up_down ? 
                                  (count_reg[11:8] + 1'b1) : 
                                  (count_reg[11:8] - 1'b1);
        end
        
        // MSB3 counter
        if (carry2) begin
            count_msb3 <= up_down ? 
                         (count_reg[15:12] + 1'b1) : 
                         (count_reg[15:12] - 1'b1);
        end
    end
end

// Final count value assembly
assign next_count = {count_msb3, count_msb2, count_msb1, count_lsb};

// Output assignment (can choose between binary or Gray code)
assign count = count_reg;  // or gray_count for Gray code output

// Sequential update
always @(posedge gated_clk) begin
    if (reset) begin
        count_reg <= 16'b0;
    end else if (enable) begin
        count_reg <= next_count;
    end
end

endmodule