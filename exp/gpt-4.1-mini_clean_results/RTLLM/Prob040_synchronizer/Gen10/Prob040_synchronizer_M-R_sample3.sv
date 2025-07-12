module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output wire [3:0]  dataout
);

    // clk_a domain registers with synchronous reset
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                en_data_reg <= 1'b0;
            end
        end
    end

    // Two-stage synchronizer for enable signal in clk_b domain
    wire en_sync_1, en_sync_2;

    sync2 sync_en (
        .clk(clk_b),
        .rstn(brstn),
        .din(en_data_reg),
        .dout2(en_sync_2),
        .dout1(en_sync_1)
    );

    // Data register holding latest synchronized output data in clk_b domain
    reg [3:0] dataout_reg;
    always @(posedge clk_b) begin
        if (!brstn) begin
            dataout_reg <= 4'd0;
        end else begin
            if (en_sync_2)
                dataout_reg <= data_reg;
        end
    end

    assign dataout = dataout_reg;

endmodule

// Two-stage synchronizer module
module sync2 (
    input  wire clk,
    input  wire rstn,
    input  wire din,
    output reg  dout1,
    output reg  dout2
);
    always @(posedge clk) begin
        if (!rstn) begin
            dout1 <= 1'b0;
            dout2 <= 1'b0;
        end else begin
            dout1 <= din;
            dout2 <= dout1;
        end
    end
endmodule