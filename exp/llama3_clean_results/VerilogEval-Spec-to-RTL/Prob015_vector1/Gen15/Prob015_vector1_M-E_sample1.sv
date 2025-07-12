// Define the PipelinedSplitter module
module PipelinedSplitter(
    input           clk,  // Clock signal
    input           rst_n,  // Active-low reset
    input  [15:0]   in,    // 16-bit input
    output [7:0]    out_hi,  // Upper byte output
    output [7:0]    out_lo   // Lower byte output
);

    reg [15:0]      in_reg;  // Registered input

    // Input register stage
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            in_reg <= 16'd0;
        end else begin
            in_reg <= in;
        end
    end

    // Splitter stage
    assign out_hi = in_reg[15:8];
    assign out_lo = in_reg[7:0];

endmodule

// Define the TopModule that instantiates the PipelinedSplitter
module TopModule(
    input           clk,  // Clock signal
    input           rst_n,  // Active-low reset
    input  [15:0]   in,    // 16-bit input
    output [7:0]    out_hi,  // Upper byte output
    output [7:0]    out_lo   // Lower byte output
);

    // Instantiate the PipelinedSplitter
    PipelinedSplitter splitter(
       .clk(clk),
       .rst_n(rst_n),
       .in(in),
       .out_hi(out_hi),
       .out_lo(out_lo)
    );

endmodule