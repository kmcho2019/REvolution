module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg_a;
    reg en_reg_a;

    // Clock domain B registers
    reg en_sync1_b, en_sync2_b;
    reg [3:0] data_reg_b;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a <= data_en;
        end
    end

    // Clock domain crossing - enable synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1_b <= 1'b0;
            en_sync2_b <= 1'b0;
        end else begin
            en_sync1_b <= en_reg_a;
            en_sync2_b <= en_sync1_b;
        end
    end

    // Clock domain B output logic
    assign load_data = en_sync2_b;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (load_data) begin
            dataout <= data_reg_a;
        end
    end

endmodule