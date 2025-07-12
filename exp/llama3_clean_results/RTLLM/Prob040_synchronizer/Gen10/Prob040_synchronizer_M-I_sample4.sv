module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       en_clap_one;
reg       en_clap_two;
reg       clk_a_gated;

// Clock gating for clk_a to reduce power
always @(posedge clk_a) begin
    if (data_en) begin
        clk_a_gated <= 1'b1;
    end else begin
        clk_a_gated <= 1'b0;
    end
end

// Update data_reg and en_data_reg in clock domain A with gated clock
always @(posedge clk_a) begin
    if (clk_a_gated) begin
        if (!arstn) begin
            data_reg <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= 1'b1;
        end
    end
end

// Update en_clap_one and en_clap_two in clock domain B with simplified logic
always @(posedge clk_b) begin
    if (!arstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Update dataout in clock domain B
always @(posedge clk_b) begin
    if (!arstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule