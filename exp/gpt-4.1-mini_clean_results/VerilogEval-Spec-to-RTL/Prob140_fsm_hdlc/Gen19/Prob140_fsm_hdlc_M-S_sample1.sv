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
            // Outputs based on previous count and current input (Moore FSM one cycle delay)
            disc <= (count == 3'd5) && (in == 1'b0);
            flag <= (count == 3'd6) && (in == 1'b0);
            err  <= (count >= 3'd6) && (in == 1'b1);

            // Update count: reset on zero input, saturate at 7 on ones
            if (in) begin
                if (count < 3'd7)
                    count <= count + 3'd1;
                else
                    count <= 3'd7;
            end else begin
                count <= 3'd0;
            end
        end
    end

endmodule