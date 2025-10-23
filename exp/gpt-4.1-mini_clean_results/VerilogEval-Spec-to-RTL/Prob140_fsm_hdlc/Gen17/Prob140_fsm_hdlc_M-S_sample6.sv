module TopModule(
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
                // Increment count saturating at 7
                if (count < 3'd7)
                    count <= count + 3'd1;
                else
                    count <= 3'd7;

                // Error if already 6 or more consecutive ones and another one comes
                if (count >= 3'd6)
                    err <= 1'b1;
            end else begin
                // Zero resets count and triggers disc or flag output accordingly
                if (count == 3'd5)
                    disc <= 1'b1;
                else if (count == 3'd6)
                    flag <= 1'b1;
                count <= 3'd0;
            end
        end
    end

endmodule