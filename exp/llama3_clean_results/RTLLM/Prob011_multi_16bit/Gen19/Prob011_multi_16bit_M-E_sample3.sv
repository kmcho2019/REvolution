module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Internal signals and registers
reg [31:0] product;
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [3:0] count;
reg start_pulse;

// Pipeline registers
reg [31:0] pipe_reg1;
reg [31:0] pipe_reg2;

always @(posedge clk) begin
    if (!rst_n) begin
        product <= 32'd0;
        multiplicand <= 16'd0;
        multiplier <= 16'd0;
        count <= 4'd0;
        start_pulse <= 1'b0;
        pipe_reg1 <= 32'd0;
        pipe_reg2 <= 32'd0;
    end else begin
        // Stage 1: Load inputs and initialize
        if (start && count == 4'd0) begin
            multiplicand <= ain;
            multiplier <= bin;
            start_pulse <= 1'b1;
            count <= count + 1'b1;
        end
        
        // Stage 2: Perform multiplication for MSBs using Booth multiplier
        if (start_pulse && count == 4'd1) begin
            // Booth multiplier logic for MSBs
            product <= product + (multiplier[15:8] * multiplicand[15:8]);
            pipe_reg1 <= product;
            count <= count + 1'b1;
        end
        
        // Stage 3: Perform multiplication for LSBs using array multiplier
        if (start_pulse && count == 4'd2) begin
            // Array multiplier logic for LSBs
            product <= product + (multiplier[7:0] * multiplicand[7:0]);
            pipe_reg2 <= product;
            count <= count + 1'b1;
        end
        
        // Stage 4: Finalize product and set done flag
        if (start_pulse && count == 4'd3) begin
            product <= pipe_reg2;
            done <= 1'b1;
            count <= 4'd0;
            start_pulse <= 1'b0;
        end
    end
end

assign yout = product;

endmodule