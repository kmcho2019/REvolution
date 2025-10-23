module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // ------- clk_a domain ---------
    // Latch data and data_valid when data_en asserted
    reg [3:0] data_staged;
    reg       data_valid_a;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_staged  <= 4'd0;
            data_valid_a <= 1'b0;
        end else begin
            if (data_en) begin
                data_staged  <= data_in;
                data_valid_a <= 1'b1;
            end else begin
                data_valid_a <= 1'b0;
            end
        end
    end

    // ------- clk_b domain ---------
    // Synchronize data_valid signal from clk_a domain to clk_b domain
    reg data_valid_b_ff1, data_valid_b_ff2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_valid_b_ff1 <= 1'b0;
            data_valid_b_ff2 <= 1'b0;
        end else begin
            data_valid_b_ff1 <= data_valid_a;
            data_valid_b_ff2 <= data_valid_b_ff1;
        end
    end

    // Detect rising edge of synchronized data_valid to know new data available
    wire data_valid_b_rising = data_valid_b_ff1 & ~data_valid_b_ff2;

    // Register to capture new data on rising edge of data_valid in clk_b domain
    reg [3:0] data_captured;
    reg       data_captured_valid;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_captured       <= 4'd0;
            data_captured_valid <= 1'b0;
            dataout             <= 4'd0;
        end else begin
            if (data_valid_b_rising) begin
                data_captured       <= data_staged;  // asynchronous capture from clk_a domain
                data_captured_valid <= 1'b1;
            end
            // Update output when new data captured valid
            if (data_captured_valid) begin
                dataout <= data_captured;
                data_captured_valid <= 1'b0; // clear valid once dataout updated
            end
            // else dataout holds previous value
        end
    end

endmodule