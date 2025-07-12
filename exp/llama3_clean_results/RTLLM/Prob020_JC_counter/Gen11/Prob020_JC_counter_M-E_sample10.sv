module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Define the 16-bit Johnson counter module
module JC_counter_16(
    input clk,
    input rst_n,
    output reg [15:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 16'd0;
    end else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[15:1]};
        end else begin
            Q <= {1'b0, Q[15:1]};
        end
    end
end

endmodule

// Instantiate four 16-bit Johnson counters
wire [15:0] seg1, seg2, seg3, seg4;
JC_counter_16 seg1_inst(
   .clk(clk),
   .rst_n(rst_n),
   .Q(seg1)
);

JC_counter_16 seg2_inst(
   .clk(clk),
   .rst_n(rst_n),
   .Q(seg2)
);

JC_counter_16 seg3_inst(
   .clk(clk),
   .rst_n(rst_n),
   .Q(seg3)
);

JC_counter_16 seg4_inst(
   .clk(clk),
   .rst_n(rst_n),
   .Q(seg4)
);

// Combine the outputs of the four segments
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= {seg4, seg3, seg2, seg1};
    end
end

endmodule