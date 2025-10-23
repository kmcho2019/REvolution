module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // Register data_in and data_en only when data_en is asserted in clk_a domain
    reg [3:0] data_reg_a;
    reg       data_en_a;
    reg       data_update_flag_a;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a       <= 4'b0;
            data_en_a        <= 1'b0;
            data_update_flag_a <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg_a <= data_in;
                data_en_a  <= 1'b1;
                data_update_flag_a <= ~data_update_flag_a;  // Toggle flag to indicate new data
            end else begin
                data_en_a <= 1'b0;
                // data_reg_a holds previous value
                // data_update_flag_a unchanged if no new data
            end
        end
    end

    // Synchronize the data_update_flag_a to clk_b domain to detect data updates safely
    reg data_update_flag_b1, data_update_flag_b2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_update_flag_b1 <= 1'b0;
            data_update_flag_b2 <= 1'b0;
        end else begin
            data_update_flag_b1 <= data_update_flag_a;
            data_update_flag_b2 <= data_update_flag_b1;
        end
    end

    wire data_update_pulse_b = data_update_flag_b1 ^ data_update_flag_b2; // Rising edge detection in clk_b domain

    // Two-stage synchronization of data_en_a to clk_b domain (enable delayed by 2 cycles)
    reg en_clap_one, en_clap_two;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= data_en_a;
            en_clap_two <= en_clap_one;
        end
    end

    // Register to hold the latest sampled data from clk_a domain, clocked by clk_b,
    // only update when data_update_pulse_b is high and delayed enable en_clap_two is active
    reg [3:0] data_reg_b;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
            dataout    <= 4'b0;
        end else begin
            if (data_update_pulse_b && en_clap_two) begin
                data_reg_b <= data_reg_a;
                dataout    <= data_reg_a;
            end else begin
                // retain previous values
                // data_reg_b and dataout unchanged
            end
        end
    end

endmodule