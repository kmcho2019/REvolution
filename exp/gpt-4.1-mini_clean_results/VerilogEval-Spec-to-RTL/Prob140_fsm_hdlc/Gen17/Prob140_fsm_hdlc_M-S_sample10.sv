module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            if (in) begin
                if (count == 3'd6) begin
                    err <= 1'b1;    // 7 or more consecutive 1s
                    count <= 3'd7;  // Saturate at 7
                end else if (count < 3'd7) begin
                    count <= count + 1;
                end
            end else begin
                // in == 0: check for disc or flag based on count
                if (count == 3'd5)
                    disc <= 1'b1;
                else if (count == 3'd6)
                    flag <= 1'b1;
                count <= 3'd0;
            end
        end
    end

endmodule