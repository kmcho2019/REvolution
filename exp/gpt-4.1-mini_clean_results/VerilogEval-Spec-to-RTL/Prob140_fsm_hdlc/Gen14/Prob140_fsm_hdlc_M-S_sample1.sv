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
            // Update count saturating at 7
            count <= (in && count < 3'd7) ? count + 3'd1 : (in ? 3'd7 : 3'd0);

            // Outputs asserted one cycle after detection (Moore outputs)
            disc <= (count == 3'd5) && !in;   // zero after five ones
            flag <= (count == 3'd6) && !in;   // six ones then zero (flag)
            err  <= (in && count >= 3'd6);    // seven or more ones
        end
    end

endmodule