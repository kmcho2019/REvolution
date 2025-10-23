module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
        // else hold previous value
    end

    // Synchronize data_en from clk_a to clk_b domain
    reg en_sync_ff1, en_sync_ff2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_ff1 <= 1'b0;
            en_sync_ff2 <= 1'b0;
        end else begin
            en_sync_ff1 <= data_en;
            en_sync_ff2 <= en_sync_ff1;
        end
    end

    // Detect rising edge (pulse) of synchronized data_en in clk_b domain
    wire en_rising_edge = en_sync_ff1 & (~en_sync_ff2);

    // Register to store the data_reg from clk_a domain into clk_b domain synchronously with pulse
    // Since data_reg is from clk_a domain, use the pulse to latch it safely assuming data_reg stable during data_en high
    reg [3:0] data_reg_clkb;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_clkb <= 4'd0;
        end else if (en_rising_edge) begin
            data_reg_clkb <= data_reg;
        end
        // else hold previous value
    end

    // Output dataout update on rising edge pulse
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_rising_edge) begin
            dataout <= data_reg_clkb;
        end
        // else hold previous dataout
    end

endmodule