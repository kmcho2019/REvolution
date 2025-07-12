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
            // Update count: increment if in=1 (saturate at 7), else reset to 0
            count <= (in) ? ((count < 3'd7) ? count + 1 : 3'd7) : 3'd0;

            // Outputs depend on previous count and current input, delayed by one cycle:
            disc <= (count == 3'd5) && (in == 1'b0);
            flag <= (count == 3'd6) && (in == 1'b0);
            err  <= (count >= 3'd6) && (in == 1'b1);
        end
    end

endmodule