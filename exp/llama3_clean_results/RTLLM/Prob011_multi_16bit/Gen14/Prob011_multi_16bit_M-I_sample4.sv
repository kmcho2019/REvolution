module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
reg [31:0] yout_r;
reg done_r;
reg clock_enable;

// Pipelining: Breaking down the multiplication into stages
reg [15:0] areg, breg;
reg [31:0] prod_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        clock_enable <= 1'b0;
        areg <= 16'd0;
        breg <= 16'd0;
        prod_reg <= 32'd0;
    end else begin
        if (start && !clock_enable) begin
            // Stage 1: Load inputs
            areg <= ain;
            breg <= bin;
            prod_reg <= 32'd0;
            clock_enable <= 1'b1;
            i <= 5'd1;
        end else if (clock_enable) begin
            if (i < 5'd17) begin
                // Stage 2: Shift and Accumulate
                if (areg[i-1] == 1'b1) begin
                    prod_reg <= prod_reg + (breg << (i-1));
                end
                i <= i + 1'b1;
                if (i == 5'd16) begin
                    done_r <= 1'b1;
                end
            end else begin
                // Completion
                clock_enable <= 1'b0;
                yout_r <= prod_reg;
                if (!start) begin
                    i <= 5'd0;
                    areg <= 16'd0;
                    breg <= 16'd0;
                    prod_reg <= 32'd0;
                    done_r <= 1'b0;
                end
            end
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule