module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] count_ones;

    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            // Default outputs deasserted
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            if (in) begin
                if (count_ones == 3'd6)
                    err <= 1'b1;  // 7 or more consecutive ones -> error
                if (count_ones < 3'd7)
                    count_ones <= count_ones + 3'd1; // count ones up to 7 max
            end else begin
                // input zero: check previous count_ones for outputs
                if (count_ones == 3'd5)
                    disc <= 1'b1;  // inserted zero after 5 ones
                else if (count_ones == 3'd6)
                    flag <= 1'b1;  // flag pattern detected
                count_ones <= 3'd0; // reset count on zero input
            end
        end
    end

endmodule