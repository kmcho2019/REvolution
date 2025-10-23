module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [4:0] i;            // Shift counter (0-16)
reg [15:0] areg, breg;  // Multiplicand and multiplier registers
reg [31:0] yout_r;      // Product register
reg [31:0] pp_reg;      // Pipeline register for partial products
reg done_r;             // Done flag register
reg active;             // Active computation flag

// Clock gating control
wire clk_en = start || (i > 0) || !done_r;
wire gated_clk = clk & clk_en;

// Counter and control logic - optimized
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
        active <= 1'b0;
    end else begin
        if (start && !active) begin
            i <= 5'd1;
            active <= 1'b1;
        end else if (active) begin
            if (i < 5'd16) begin
                i <= i + 5'd1;
            end else begin
                i <= 5'd0;
                active <= 1'b0;
            end
        end
    end
end

// Done flag generation - simplified
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else begin
        done_r <= (i == 5'd16);
    end
end

// Shift and accumulate operation with pipelining
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        pp_reg <= 32'd0;
    end else begin
        if (start && !active) begin
            // Initial load
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
            pp_reg <= 32'd0;
        end else if (active) begin
            // Pipeline stage 1: calculate partial product
            pp_reg <= areg << (i-1);
            
            // Pipeline stage 2: accumulate if multiplier bit is set
            if (breg[i-1]) begin
                yout_r <= yout_r + pp_reg;
            end
        end
    end
end

// Gated output assignment
always @(*) begin
    yout = done_r ? yout_r : 32'd0;
end

assign done = done_r;

endmodule