module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) 
            q <= 3'd4;           // Force q to 4 when a=1
        else begin
            if (q == 3'd6)
                q <= 3'd0;       // Wrap-around modulo 7
            else
                q <= q + 3'd1;   // Increment q by 1
        end
    end

endmodule