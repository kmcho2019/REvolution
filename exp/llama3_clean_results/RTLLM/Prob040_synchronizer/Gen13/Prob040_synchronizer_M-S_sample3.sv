module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg en_clap_one; // First enable control register
reg en_clap_two; // Second enable control register

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
    end else begin
        en_clap_one <= data_en;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_in;
    end else begin
        // Retain previous value
    end
end

endmodule