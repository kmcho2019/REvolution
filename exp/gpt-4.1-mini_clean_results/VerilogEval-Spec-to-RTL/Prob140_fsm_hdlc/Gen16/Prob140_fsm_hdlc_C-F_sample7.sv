module TopModule (
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
            disc       <= 1'b0;
            flag       <= 1'b0;
            err        <= 1'b0;
        end else begin
            // Default outputs deasserted
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            if (in) begin
                // Increment count up to saturation at 7
                if (count_ones < 3'd7)
                    count_ones <= count_ones + 3'd1;
                else
                    count_ones <= 3'd7;

                // Assert err if count saturates at 7 (7 or more consecutive ones)
                if (count_ones == 3'd6 || count_ones == 3'd7)
                    err <= 1'b1;
            end else begin
                // Input zero: check previous count for special sequences
                if (count_ones == 3'd5)
                    disc <= 1'b1; // discard inserted zero bit
                else if (count_ones == 3'd6)
                    flag <= 1'b1; // flag detected

                // Reset count after zero input
                count_ones <= 3'd0;
            end
        end
    end

endmodule