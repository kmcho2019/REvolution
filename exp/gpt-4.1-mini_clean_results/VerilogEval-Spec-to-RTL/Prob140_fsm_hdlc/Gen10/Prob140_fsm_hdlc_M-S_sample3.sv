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
            // Update count: increment saturating at 7 or reset on zero input
            if (in) begin
                count <= (count < 3'd7) ? count + 3'd1 : 3'd7;
            end else begin
                count <= 3'd0;
            end

            // Outputs asserted one cycle after condition
            disc <= (count == 3'd5) && (in == 1'b0);
            flag <= (count == 3'd6) && (in == 1'b0);
            err  <= (in && count == 3'd7);
        end
    end

endmodule