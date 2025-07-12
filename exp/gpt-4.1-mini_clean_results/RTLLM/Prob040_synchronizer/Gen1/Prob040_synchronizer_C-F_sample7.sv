module synchronizer (
    input         clk_a,
    input         clk_b,
    input         arstn,
    input         brstn,
    input  [3:0]  data_in,
    input         data_en,
    output reg [3:0] dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Registers in clk_b domain for enable signal delay
reg en_clap_one, en_clap_two;

// clk_a domain: capture data_in and data_en with async active-low reset
// Update data_reg and en_data_reg only when data_en is high to reduce toggling
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        if (data_en) begin
            data_reg    <= data_in;
            en_data_reg <= 1'b1;
        end else begin
            // Keep en_data_reg low when data_en is low
            en_data_reg <= 1'b0;
            // Keep data_reg unchanged to reduce toggling since data_in is stable during data_en
        end
    end
end

// clk_b domain: two flip-flops to synchronize and delay en_data_reg signal
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// clk_b domain: output assignment using mux-based selection based on en_clap_two
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout; // Hold previous value
    end
end

endmodule