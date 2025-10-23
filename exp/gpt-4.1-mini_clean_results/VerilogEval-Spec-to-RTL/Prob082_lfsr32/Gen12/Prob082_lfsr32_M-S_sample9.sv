module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            wire feedback = q[0];
            q <= { 
                feedback ^ q[31],       // bit 31 (tap 32)
                q[31:22],              // bits 30 down to 22 (except 21)
                feedback ^ q[21],       // bit 21 (tap 22)
                q[20:2],               // bits 20 down to 2 (except 1)
                feedback ^ q[1],        // bit 1 (tap 2)
                feedback ^ q[0]         // bit 0 (tap 1)
            };
        end
    end

endmodule