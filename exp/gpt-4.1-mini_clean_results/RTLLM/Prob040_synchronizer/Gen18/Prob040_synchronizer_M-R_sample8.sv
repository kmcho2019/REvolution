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
    reg       en_reg;

    // Data enable signal used as clock enable for data_reg update
    wire update_data = data_en;

    always @(posedge clk_a) begin
        if (~arstn) begin
            data_reg <= 4'd0;
            en_reg   <= 1'b0;
        end else begin
            en_reg <= data_en;
            // update data_reg only when update_data is true
            if (update_data) begin
                data_reg <= data_in;
            end
        end
    end

    // ----- enable synchronizer submodule -----
    wire en_sync2;

    enable_sync u_enable_sync (
        .clk_b   (clk_b),
        .brstn   (brstn),
        .en_in   (en_reg),
        .en_out  (en_sync2)
    );

    // ----- clk_b domain dataout update -----
    reg [3:0] dataout_next;

    always @(*) begin
        if (en_sync2)
            dataout_next = data_reg;
        else
            dataout_next = dataout;  // hold previous value
    end

    always @(posedge clk_b) begin
        if (~brstn)
            dataout <= 4'd0;
        else
            dataout <= dataout_next;
    end

endmodule


// Two-stage synchronizer for enable from clk_a to clk_b domain
module enable_sync (
    input  wire clk_b,
    input  wire brstn,
    input  wire en_in,
    output wire en_out
);

    reg en_sync1, en_sync2;

    always @(posedge clk_b) begin
        if (~brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_in;
            en_sync2 <= en_sync1;
        end
    end

    assign en_out = en_sync2;

endmodule