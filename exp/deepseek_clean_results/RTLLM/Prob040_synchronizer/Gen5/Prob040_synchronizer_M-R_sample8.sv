module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output wire [3:0] dataout
);

    // Data path registers
    reg [3:0] data_reg;
    reg en_data_reg;
    
    // Synchronization path registers
    wire en_clap_one, en_clap_two;
    
    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Instantiate DFFs for synchronization chain
    dff_sync dff1 (
        .clk(clk_b),
        .rstn(brstn),
        .d(en_data_reg),
        .q(en_clap_one)
    );
    
    dff_sync dff2 (
        .clk(clk_b),
        .rstn(brstn),
        .d(en_clap_one),
        .q(en_clap_two)
    );
    
    // Data output register
    reg [3:0] dataout_reg;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout_reg <= 4'b0;
        end else if (en_clap_two) begin
            dataout_reg <= data_reg;
        end
    end
    
    assign dataout = dataout_reg;

endmodule

// Basic D flip-flop with async reset
module dff_sync (
    input wire clk,
    input wire rstn,
    input wire d,
    output reg q
);
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule