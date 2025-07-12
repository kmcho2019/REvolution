module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Named states using counter values
    parameter [2:0] CNT_0 = 3'd0,
                   CNT_1 = 3'd1,
                   CNT_2 = 3'd2,
                   CNT_3 = 3'd3,
                   CNT_4 = 3'd4,
                   CNT_5 = 3'd5,
                   CNT_6 = 3'd6,
                   CNT_7 = 3'd7;

    reg [2:0] count;
    wire next_err = (count >= CNT_6) && in;

    always @(posedge clk) begin
        if (reset) begin
            count <= CNT_0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // State transitions
            if (in) begin
                if (count < CNT_7) count <= count + 1;
            end else begin
                count <= CNT_0;
            end

            // Output generation (only set when needed)
            disc <= (count == CNT_5) && !in;
            flag <= (count == CNT_6) && !in;
            err <= next_err;
        end
    end

endmodule