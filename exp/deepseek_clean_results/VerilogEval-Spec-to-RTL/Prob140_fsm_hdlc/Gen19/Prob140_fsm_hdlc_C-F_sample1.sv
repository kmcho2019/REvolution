module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    parameter [2:0] CNT_0 = 0,
                   CNT_1 = 1,
                   CNT_2 = 2,
                   CNT_3 = 3,
                   CNT_4 = 4,
                   CNT_5 = 5,
                   CNT_6 = 6,
                   CNT_ERR = 7;

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= CNT_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Only update outputs when conditions met (power optimization)
            disc <= 0;
            flag <= 0;
            err <= 0;

            if (count == CNT_ERR) begin
                // Stay in error state until reset
                err <= 1;
            end else if (in) begin
                // Count consecutive 1s
                if (count < CNT_6) begin
                    count <= count + 1;
                end else begin
                    // Enter and stay in error state
                    count <= CNT_ERR;
                    err <= 1;
                end
            end else begin
                // Check for disc and flag conditions
                if (count == CNT_5) disc <= 1;
                if (count == CNT_6) flag <= 1;
                count <= CNT_0;
            end
        end
    end

endmodule