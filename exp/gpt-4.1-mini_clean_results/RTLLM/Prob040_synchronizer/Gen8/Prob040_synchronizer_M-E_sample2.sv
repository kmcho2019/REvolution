module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // Double-buffer data registers in clk_a domain: current and previous stable data
    reg [3:0] data_reg_curr;
    reg [3:0] data_reg_prev;
    reg       en_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_curr <= 4'd0;
            data_reg_prev <= 4'd0;
            en_reg        <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg_prev <= data_reg_curr;
                data_reg_curr <= data_in;
            end
            en_reg <= data_en;
        end
    end

    // Synchronizer chain for enable signal in clk_b domain
    reg en_sync_1, en_sync_2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_1 <= 1'b0;
            en_sync_2 <= 1'b0;
        end else begin
            en_sync_1 <= en_reg;
            en_sync_2 <= en_sync_1;
        end
    end

    // Edge detection of delayed enable signal: rising edge triggers output update
    reg en_sync_2_dly;
    wire en_sync_rising = en_sync_2 & ~en_sync_2_dly;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_2_dly <= 1'b0;
        end else begin
            en_sync_2_dly <= en_sync_2;
        end
    end

    // MUX selects previous or current data based on delayed enable:
    // when en_sync_2 is low, output retains old value (no update),
    // when en_sync_2 rises, update output with current data_reg_curr,
    // else output holds previous data_reg_prev.
    wire [3:0] selected_data = en_sync_2 ? data_reg_curr : data_reg_prev;

    // Update output dataonly on rising edge of delayed enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_sync_rising) begin
            dataout <= selected_data;
        end
    end

endmodule