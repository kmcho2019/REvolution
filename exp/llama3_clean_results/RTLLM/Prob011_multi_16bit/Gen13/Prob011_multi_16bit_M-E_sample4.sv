module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] ain_reg;
reg [15:0] bin_reg;
reg [31:0] partial_product;
reg [31:0] accumulated_product;
reg [4:0] i;
reg start_reg;
reg done_reg;

// Input Buffering Stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ain_reg <= 0;
        bin_reg <= 0;
        start_reg <= 0;
    end else if (start) begin
        ain_reg <= ain;
        bin_reg <= bin;
        start_reg <= 1;
    end else if (!start && start_reg) begin
        start_reg <= 0;
    end
end

// Partial Product Generation Stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= 0;
    end else if (start_reg) begin
        if (ain_reg[0]) begin
            partial_product <= bin_reg;
        end else begin
            partial_product <= 0;
        end
    end
end

// Accumulation Stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulated_product <= 0;
        i <= 0;
    end else if (start_reg) begin
        if (i < 16) begin
            if (ain_reg[i]) begin
                accumulated_product <= accumulated_product + (bin_reg << i);
            end
            i <= i + 1;
        end
    end else if (!start_reg && i >= 16) begin
        i <= 0;
        accumulated_product <= 0;
    end
end

// Output Buffering Stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        yout <= 0;
        done_reg <= 0;
    end else if (start_reg && i >= 16) begin
        yout <= accumulated_product;
        done_reg <= 1;
    end else if (!start_reg) begin
        done_reg <= 0;
    end
end

assign done = done_reg;

endmodule