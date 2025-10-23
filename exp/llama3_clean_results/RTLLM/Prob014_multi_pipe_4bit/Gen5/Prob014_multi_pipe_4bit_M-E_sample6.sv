module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// First stage of pipeline: shift and add
reg [7:0] stage1_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_out <= 8'd0;
    end else begin
        stage1_out <= ((mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0) +
                       ((mul_b[1] == 1'b1) ? {4'b0, mul_a} << 1 : 8'd0);
    end
end

// Second stage of pipeline: accumulate
reg [7:0] stage2_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_out <= 8'd0;
    end else begin
        stage2_out <= stage1_out + ((mul_b[2] == 1'b1) ? {4'b0, mul_a} << 2 : 8'd0) +
                                        ((mul_b[3] == 1'b1) ? {4'b0, mul_a} << 3 : 8'd0);
    end
end

// Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= stage2_out;
    end
end

endmodule