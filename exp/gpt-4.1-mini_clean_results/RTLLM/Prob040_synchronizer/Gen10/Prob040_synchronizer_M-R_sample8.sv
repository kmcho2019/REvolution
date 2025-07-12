module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Wire for synchronized enable signal in clk_b domain
    wire en_sync;

    // clk_a domain: latch data_reg only when data_en is high; latch en_data_reg every clk_a posedge
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // Instantiate two-stage synchronizer for enable signal en_data_reg from clk_a to clk_b domain
    two_stage_sync u_sync (
        .clk    (clk_b),
        .rstn   (brstn),
        .in_sig (en_data_reg),
        .out_sig(en_sync)
    );

    // Output update logic on clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            if (en_sync)
                dataout <= data_reg;
            // else dataout holds its previous value
        end
    end

endmodule

// Two-stage synchronizer for single-bit signal crossing from clk_a to clk_b domain
module two_stage_sync (
    input  wire clk,
    input  wire rstn,
    input  wire in_sig,
    output wire out_sig
);
    reg sync_ff1, sync_ff2;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
        end else begin
            sync_ff1 <= in_sig;
            sync_ff2 <= sync_ff1;
        end
    end

    assign out_sig = sync_ff2;

endmodule