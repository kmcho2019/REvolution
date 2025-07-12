module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count (0 to 17)
    reg          done_r;
    reg [15:0]   ain_reg;    // registered multiplicand
    reg [15:0]   bin_reg;    // registered multiplier
    reg [31:0]   yout_r;     // accumulator for product

    wire cnt_enable = start && (i < 5'd17);
    wire load_inputs = start && (i == 5'd0);
    wire accumulate_enable = (i > 0) && (i < 17) && ain_reg[i-1];

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (cnt_enable)
            i <= i + 5'd1;
    end

    // Done flag update: set at i==16, cleared on reset or start deassertion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (!start)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
    end

    // Input registers load and accumulator update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ain_reg <= 16'd0;
            bin_reg <= 16'd0;
            yout_r  <= 32'd0;
        end else if (!start) begin
            ain_reg <= 16'd0;
            bin_reg <= 16'd0;
            yout_r  <= 32'd0;
        end else begin
            if (load_inputs) begin
                ain_reg <= ain;
                bin_reg <= bin;
                yout_r <= 32'd0;
            end else if (accumulate_enable) begin
                // Add bin_reg shifted left by (i-1) to accumulator
                yout_r <= yout_r + ({16'd0, bin_reg} << (i-1));
            end
            // else keep yout_r unchanged during other cycles
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule