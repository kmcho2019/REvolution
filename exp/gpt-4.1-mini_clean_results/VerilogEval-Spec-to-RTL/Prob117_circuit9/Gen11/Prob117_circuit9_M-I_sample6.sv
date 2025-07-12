module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Synchronous reset on first clock to initialize q to 4 (matching initial stable state)
reg init_done;

always @(posedge clk) begin
    if (!init_done) begin
        q <= 3'd4;
        init_done <= 1'b1;
    end else begin
        if (a)
            q <= 3'd4;
        else begin
            // Increment modulo 7
            if (q == 3'd6)
                q <= 3'd0;
            else
                q <= q + 3'd1;
        end
    end
end

endmodule