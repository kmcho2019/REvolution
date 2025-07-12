module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

localparam RESET_VAL = 3'd4;

always @(posedge clk) begin
    if (a)
        q <= RESET_VAL;
    else begin
        // Increment q modulo 7
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

// Synchronous reset on simulation start
initial q = RESET_VAL;

endmodule