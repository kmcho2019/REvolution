module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Register to store data_in
reg data_en_reg; // Register to store data_en
reg en_delay_one; // First stage of delayed enable signal
reg en_delay_two; // Second stage of delayed enable signal

// Clock domain crossing for data_in
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Clock domain crossing for data_en
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_en_reg <= 1'd0;
    end else begin
        data_en_reg <= data_en;
    end
end

// Delay enable signal by two clk_b cycles
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay_one <= 1'd0;
        en_delay_two <= 1'd0;
    end else begin
        en_delay_one <= data_en_reg;
        en_delay_two <= en_delay_one;
    end
end

// Assign output dataout based on delayed enable signal
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_delay_two) begin
        dataout <= data_reg;
    end
end

endmodule