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
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;
reg [1:0] state;

// State machine
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
        state <= 2'b00;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
        case (state)
            2'b00: begin
                if (data_en) state <= 2'b01;
                else state <= 2'b00;
            end
            2'b01: state <= 2'b10;
            2'b10: state <= 2'b11;
            2'b11: begin
                if (!data_en) state <= 2'b00;
                else state <= 2'b11;
            end
        endcase
    end
end

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment
assign dataout = (brstn && en_clap_two)? data_reg : dataout;

endmodule