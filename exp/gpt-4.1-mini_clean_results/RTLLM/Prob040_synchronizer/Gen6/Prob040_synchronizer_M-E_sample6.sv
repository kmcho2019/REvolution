module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain (async)
    input  wire        brstn,     // active-low reset clk_b domain (async)
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain signals
    reg [3:0] data_reg;
    reg       data_req_toggle;

    // clk_b domain signals
    reg       data_req_sync_0;
    reg       data_req_sync_1;
    reg       data_req_sync_2;  // for edge detection

    // clk_a domain: latch data_in and toggle request on data_en
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg        <= 4'b0;
            data_req_toggle <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg        <= data_in;
                data_req_toggle <= ~data_req_toggle; // toggle to signal new data
            end
        end
    end

    // clk_b domain: synchronize toggle and detect edges to latch data_reg
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_req_sync_0 <= 1'b0;
            data_req_sync_1 <= 1'b0;
            data_req_sync_2 <= 1'b0;
            dataout         <= 4'b0;
        end else begin
            // synchronize toggle through 2 FFs
            data_req_sync_0 <= data_req_toggle;
            data_req_sync_1 <= data_req_sync_0;
            data_req_sync_2 <= data_req_sync_1;

            // detect rising edge of synchronized toggle
            if ((data_req_sync_1 ^ data_req_sync_2) & data_req_sync_1) begin
                // On toggle edge, latch data_reg value safely
                dataout <= data_reg;
            end
        end
    end

endmodule