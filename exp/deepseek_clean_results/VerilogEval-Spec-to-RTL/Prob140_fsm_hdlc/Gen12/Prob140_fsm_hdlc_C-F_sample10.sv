module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Named states for clarity while maintaining counter efficiency
    parameter [2:0] CNT_0 = 3'd0,
                   CNT_1 = 3'd1,
                   CNT_2 = 3'd2,
                   CNT_3 = 3'd3,
                   CNT_4 = 3'd4,
                   CNT_5 = 3'd5,
                   CNT_6 = 3'd6,
                   CNT_7 = 3'd7;

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= CNT_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (no clearing to reduce switching)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and output generation
            if (in) begin
                if (count < CNT_7) count <= count + 1;
                // Error condition (7+ consecutive 1s)
                if (count >= CNT_6) err <= 1;
            end else begin
                // Check for disc and flag conditions
                if (count == CNT_5) disc <= 1;
                if (count == CNT_6) flag <= 1;
                count <= CNT_0;
            end
        end
    end

endmodule