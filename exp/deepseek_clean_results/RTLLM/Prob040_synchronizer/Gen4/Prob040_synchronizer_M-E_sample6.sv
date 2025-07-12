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
    reg pulse_stretch;
    reg [1:0] stretch_counter;

    // clk_b domain signals
    reg [2:0] sync_chain;
    reg [3:0] data_sample [0:2];
    reg [1:0] sample_ptr;
    reg data_valid;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            pulse_stretch <= 1'b0;
            stretch_counter <= 2'b0;
        end else begin
            // Capture data when enabled
            if (data_en) begin
                data_reg <= data_in;
                pulse_stretch <= 1'b1;
                stretch_counter <= 2'b0;
            end
            // Maintain stretched pulse for 3 clk_b cycles
            else if (pulse_stretch) begin
                if (stretch_counter == 2'd2)
                    pulse_stretch <= 1'b0;
                else
                    stretch_counter <= stretch_counter + 1;
            end
        end
    end

    // clk_b domain logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_chain <= 3'b0;
            data_sample[0] <= 4'b0;
            data_sample[1] <= 4'b0;
            data_sample[2] <= 4'b0;
            sample_ptr <= 2'b0;
            data_valid <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Synchronize pulse_stretch signal
            sync_chain <= {sync_chain[1:0], pulse_stretch};

            // When synchronized pulse is detected, capture data
            if (sync_chain[2] && !sync_chain[1]) begin
                data_sample[sample_ptr] <= data_reg;
                sample_ptr <= sample_ptr + 1;
            end

            // Check for stable data when we have 3 samples
            if (sample_ptr == 2'd2) begin
                data_valid <= (data_sample[0] == data_sample[1]) && 
                             (data_sample[1] == data_sample[2]);
                sample_ptr <= 2'b0;
            end

            // Update output when data is verified stable
            if (data_valid) begin
                dataout <= data_sample[0];
                data_valid <= 1'b0;
            end
        end
    end

endmodule