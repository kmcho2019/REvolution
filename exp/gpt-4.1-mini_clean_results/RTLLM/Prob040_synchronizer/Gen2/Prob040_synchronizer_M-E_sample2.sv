module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// In clk_a domain:
// Capture data and a data_valid signal (indicates valid stable data available)
reg [3:0] data_reg_a;
reg       data_valid_a;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a   <= 4'b0;
        data_valid_a <= 1'b0;
    end else begin
        if (data_en) begin
            data_reg_a   <= data_in;
            data_valid_a <= 1'b1;
        end else begin
            data_valid_a <= 1'b0;  // Clear valid if no enable
        end
    end
end

// Synchronize data_valid signal into clk_b domain using 2-stage synchronizer
reg data_valid_b_sync1, data_valid_b_sync2;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_valid_b_sync1 <= 1'b0;
        data_valid_b_sync2 <= 1'b0;
    end else begin
        data_valid_b_sync1 <= data_valid_a;
        data_valid_b_sync2 <= data_valid_b_sync1;
    end
end

// A flag to detect rising edge of data_valid in clk_b domain (to latch data once per valid event)
reg data_valid_b_sync2_d;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_valid_b_sync2_d <= 1'b0;
    end else begin
        data_valid_b_sync2_d <= data_valid_b_sync2;
    end
end

wire data_valid_b_rising = (data_valid_b_sync2 & ~data_valid_b_sync2_d);

// To transfer data_reg_a from clk_a domain to clk_b domain, we use a simple register updated on valid event.
// Since data_reg_a is in clk_a domain, we need to safely transfer it. Because data changes infrequently and
// data_valid_a is stable for at least 3 clk_b cycles, we can treat data_reg_a as stable during data_valid_a high.
// So we can sample data_reg_a asynchronously in clk_b domain when data_valid_b_rising detected.
// To avoid metastability, sample data_reg_a asynchronously using a multi-bit synchronizer style register bank.
// Because data_valid_b_rising asserts for one clk_b cycle when data_valid is stable, we latch data_reg_a to output.

reg [3:0] data_reg_b;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_reg_b <= 4'b0;
        dataout    <= 4'b0;
    end else begin
        if (data_valid_b_rising) begin
            data_reg_b <= data_reg_a;  // sample async data_reg_a on rising edge of data_valid_b_sync2
            dataout    <= data_reg_a;
        end else begin
            // Hold dataout stable when no new data
            dataout <= dataout;
        end
    end
end

endmodule