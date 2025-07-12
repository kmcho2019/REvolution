module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt  <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            // Update counter: increment on '1' up to 7, reset on '0'
            if (in)
                cnt <= (cnt < 3'd7) ? cnt + 3'd1 : 3'd7;
            else
                cnt <= 3'd0;

            // Outputs asserted one cycle after detection:
            disc <= (cnt == 3'd5) && (in == 1'b0);
            flag <= (cnt == 3'd6) && (in == 1'b0);
            err  <= (cnt == 3'd7);
        end
    end

endmodule