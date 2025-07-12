module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State: count of consecutive ones (0 to 7)
    // 7 means 7 or more consecutive ones (error)
    reg [3:0] count_ones; 

    // Next state logic and outputs combinational logic
    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 0;
            disc <= 0;
            flag <= 0;
            err  <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err  <= 0;

            if (count_ones == 5 && in == 1'b0) begin
                // Detected stuffed zero after five 1s: discard it
                disc <= 1;
                count_ones <= 0;
            end else if (count_ones == 6 && in == 1'b0) begin
                // Detected flag 01111110
                flag <= 1;
                count_ones <= 0;
            end else if (count_ones >= 7) begin
                // Error state: 7 or more consecutive ones
                err <= 1;
                if (in == 1'b1) begin
                    count_ones <= 7; // stay in error
                end else begin
                    count_ones <= 0;
                end
            end else begin
                // Normal counting of consecutive ones
                if (in == 1'b1) begin
                    if (count_ones < 7)
                        count_ones <= count_ones + 1;
                    else
                        count_ones <= 7; // saturate at error state
                end else begin
                    count_ones <= 0;
                end
            end
        end
    end

endmodule