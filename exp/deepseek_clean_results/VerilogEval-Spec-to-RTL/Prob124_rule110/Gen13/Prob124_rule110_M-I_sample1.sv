module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [255:0] first_half;
    reg [255:0] second_half;
    reg load_delay;
    reg processing_phase;

    // Clock gating signals
    wire [511:0] neighborhood_changed;
    wire any_change;

    // Detect when neighborhoods change (for clock gating)
    assign neighborhood_changed = {q[510:0], 1'b0} ^ {1'b0, q[511:1]};
    assign any_change = |neighborhood_changed || load;

    // Processing logic (sequential with pipeline)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            processing_phase <= 0;
            load_delay <= 1;
        end else if (any_change) begin
            if (processing_phase == 0) begin
                // Process first half (bits 255:0)
                for (integer i = 0; i < 256; i = i + 1) begin
                    automatic bit left = (i == 255) ? q[256] : q[i+1];
                    automatic bit center = q[i];
                    automatic bit right = (i == 0) ? 1'b0 : q[i-1];
                    first_half[i] <= (center ^ right) | (~left & (center | right));
                end
                processing_phase <= 1;
            end else begin
                // Process second half (bits 511:256)
                for (integer i = 256; i < 512; i = i + 1) begin
                    automatic bit left = (i == 511) ? 1'b0 : q[i+1];
                    automatic bit center = q[i];
                    automatic bit right = q[i-1];
                    second_half[i-256] <= (center ^ right) | (~left & (center | right));
                end
                // Update full state
                q <= {second_half, first_half};
                processing_phase <= 0;
            end
            load_delay <= 0;
        end
    end

endmodule