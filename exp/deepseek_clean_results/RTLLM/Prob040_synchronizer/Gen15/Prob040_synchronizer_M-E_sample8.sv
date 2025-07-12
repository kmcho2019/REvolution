module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain signals
    reg [3:0] data_reg;
    reg en_pulse;

    // clk_b domain signals
    reg [1:0] stretch_counter;
    reg stretch_active;
    reg [3:0] sample1, sample2, sample3;
    reg [3:0] voted_data;
    reg error_flag;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_pulse <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
                en_pulse <= 1'b1;
            end else begin
                en_pulse <= 1'b0;
            end
        end
    end

    // Pulse stretcher in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            stretch_counter <= 2'b0;
            stretch_active <= 1'b0;
        end else begin
            if (en_pulse && !stretch_active) begin
                stretch_active <= 1'b1;
                stretch_counter <= 2'b10; // Start countdown from 2 (3 cycles)
            end else if (stretch_active) begin
                if (stretch_counter == 2'b00) begin
                    stretch_active <= 1'b0;
                end else begin
                    stretch_counter <= stretch_counter - 1'b1;
                end
            end
        end
    end

    // Triple sampling and voting logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sample1 <= 4'b0;
            sample2 <= 4'b0;
            sample3 <= 4'b0;
            voted_data <= 4'b0;
            dataout <= 4'b0;
            error_flag <= 1'b0;
        end else begin
            if (stretch_active) begin
                // Take three samples during the stretched window
                case (stretch_counter)
                    2'b10: sample1 <= data_reg;
                    2'b01: sample2 <= data_reg;
                    2'b00: sample3 <= data_reg;
                endcase

                // When window completes, perform voting
                if (stretch_counter == 2'b00) begin
                    // Majority voting logic
                    if (sample1 == sample2 || sample1 == sample3) begin
                        voted_data <= sample1;
                    end else if (sample2 == sample3) begin
                        voted_data <= sample2;
                    end else begin
                        voted_data <= sample1; // Arbitrary choice if all differ
                        error_flag <= 1'b1;    // Flag error condition
                    end

                    // Update output
                    dataout <= voted_data;
                end
            end
        end
    end

endmodule