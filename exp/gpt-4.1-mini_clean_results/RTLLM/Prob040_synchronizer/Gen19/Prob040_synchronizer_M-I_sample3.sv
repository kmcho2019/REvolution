module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active low reset clk_a domain
    input  wire        brstn,      // active low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // ----- clk_a domain -----
    reg [3:0] data_reg;
    reg       en_reg, en_sync1, en_sync2;

    // Data and enable register update on clk_a domain
    always @(posedge clk_a) begin
        if (~arstn) begin
            data_reg <= 4'd0;
            en_reg   <= 1'b0;
        end else begin
            en_reg <= data_en;
            // Update data_reg only when data_en is high to minimize switching
            if (data_en) begin
                data_reg <= data_in;
            end
        end
    end

    // ----- clk_b domain -----
    // Synchronize en_reg (from clk_a domain) into clk_b domain using two-stage synchronizer
    always @(posedge clk_b) begin
        if (~brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout  <= 4'd0;
        end else begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
            // Update dataout based on delayed enable signal
            dataout <= en_sync2 ? data_reg : dataout;
        end
    end

endmodule