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
            count <= in ? (count < 3'd7 ? count + 3'd1 : 3'd7) : 3'd0;

            disc <= (count == 3'd5) && ~in;
            flag <= (count == 3'd6) && ~in;
            err  <= in && (count >= 3'd6);
        end
    end

endmodule