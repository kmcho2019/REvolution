module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain - Data capture
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Clock A domain - Enable pulse generation
    reg en_a;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_a <= 1'b0;
        end else begin
            en_a <= data_en;
        end
    end

    // Clock B domain - Two-stage enable synchronization
    reg en_sync1, en_sync2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_a;
            en_sync2 <= en_sync1;
        end
    end

    // Clock B domain - Edge detection for synchronized enable
    reg en_sync2_prev;
    wire en_posedge = en_sync2 && !en_sync2_prev;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync2_prev <= 1'b0;
        end else begin
            en_sync2_prev <= en_sync2;
        end
    end

    // Clock B domain - Output update only when new data is available
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_posedge) begin
            dataout <= data_reg;
        end
    end

endmodule