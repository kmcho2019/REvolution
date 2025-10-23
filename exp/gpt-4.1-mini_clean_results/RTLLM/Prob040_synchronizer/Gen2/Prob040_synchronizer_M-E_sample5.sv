module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain
    input  wire        brstn,     // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;        // stores input data when data_en is high
    reg       en_data_reg;     // registered version of data_en in clk_a domain

    // Registers in clk_b domain for enable synchronization
    reg en_sync_0, en_sync_1;

    // Detect rising edge of synchronized enable in clk_b domain
    reg en_sync_1_d; // delayed version of en_sync_1 to detect rising edge

    // Register to hold synchronized data in clk_b domain
    reg [3:0] data_hold;

    // clk_a domain: capture data_in and data_en with async reset,
    // only update data_reg when data_en is high to reduce switching
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // clk_b domain: two-stage synchronizer for en_data_reg
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_0 <= 1'b0;
            en_sync_1 <= 1'b0;
        end else begin
            en_sync_0 <= en_data_reg;
            en_sync_1 <= en_sync_0;
        end
    end

    // clk_b domain: detect rising edge of synchronized enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_1_d <= 1'b0;
        end else begin
            en_sync_1_d <= en_sync_1;
        end
    end

    wire en_pulse = en_sync_1 & ~en_sync_1_d; // rising edge pulse when en_sync_1 transitions 0->1

    // clk_b domain: load data_hold with data_reg when en_pulse occurs
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_hold <= 4'd0;
        end else if (en_pulse) begin
            data_hold <= data_reg;
        end
    end

    // clk_b domain: output dataout holds data_hold, reset to zero
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            dataout <= data_hold;
        end
    end

endmodule