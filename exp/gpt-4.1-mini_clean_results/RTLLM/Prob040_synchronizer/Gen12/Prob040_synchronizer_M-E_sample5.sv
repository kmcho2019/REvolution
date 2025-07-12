module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low async reset clk_a domain
    input  wire        brstn,      // active-low async reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain signals
    reg [3:0] data_reg_a;           // holds latched data_in when data_en asserted
    reg       data_en_reg_a;        // delayed enable in clk_a domain
    reg       data_strobe_a;        // single cycle pulse indicating new valid data

    // Synchronizer of data_strobe_a into clk_b domain (2-stage synchronizer)
    reg       data_strobe_b_ff1, data_strobe_b_ff2;

    // Edge detection in clk_b domain
    reg data_strobe_b_ff2_d;

    // Data register in clk_b domain
    reg [3:0] data_reg_b;

    // clk_a domain: latch data_in when data_en is asserted and generate strobe
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a    <= 4'd0;
            data_en_reg_a <= 1'b0;
            data_strobe_a <= 1'b0;
        end else begin
            data_en_reg_a <= data_en;
            if (data_en && !data_en_reg_a) begin
                // data_en just went high: latch data_in and generate strobe
                data_reg_a    <= data_in;
                data_strobe_a <= 1'b1;
            end else begin
                data_strobe_a <= 1'b0; // pulse for one clk_a cycle only
            end
        end
    end

    // clk_b domain: synchronize data_strobe_a
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_strobe_b_ff1 <= 1'b0;
            data_strobe_b_ff2 <= 1'b0;
            data_strobe_b_ff2_d <= 1'b0;
            data_reg_b <= 4'd0;
            dataout <= 4'd0;
        end else begin
            data_strobe_b_ff1 <= data_strobe_a;
            data_strobe_b_ff2 <= data_strobe_b_ff1;

            data_strobe_b_ff2_d <= data_strobe_b_ff2;

            // Detect rising edge of synchronized strobe pulse
            if (data_strobe_b_ff2 && !data_strobe_b_ff2_d) begin
                // On pulse detection, capture data_reg_a synchronized into clk_b
                // Double-register data_reg_a via clk_b domain to avoid direct crossing
                // but problem constraints do not forbid direct latch since stable for >3 clk_b cycles

                // To be safe, sample data_reg_a via a register in clk_b clock domain (assuming data_reg_a is stable)
                // Since data_reg_a is from clk_a domain, hold stable during data_en high for many clk_b cycles,
                // safe to sample data_reg_a directly here.

                data_reg_b <= data_reg_a;
                dataout <= data_reg_a;
            end else begin
                dataout <= dataout; // hold previous value
            end
        end
    end

endmodule