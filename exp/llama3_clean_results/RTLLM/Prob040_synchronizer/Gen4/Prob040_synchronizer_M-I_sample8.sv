module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg [1:0] en_data_reg; // Using a 2-bit register to store the enable signal and its previous value
reg [3:0] dataout_reg; // Using a separate register for the output to reduce switching activity

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 2'd0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= {en_data_reg[0], data_en}; // Storing the previous value of en_data_reg and the current value of data_en
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout_reg <= 4'd0;
        dataout <= 4'd0;
    end else begin
        if (en_data_reg[1] && en_data_reg[0]) begin // Checking if the enable signal is high for at least two clock cycles
            dataout_reg <= data_reg;
        end
        dataout <= dataout_reg; // Assigning the output value
    end
end

endmodule