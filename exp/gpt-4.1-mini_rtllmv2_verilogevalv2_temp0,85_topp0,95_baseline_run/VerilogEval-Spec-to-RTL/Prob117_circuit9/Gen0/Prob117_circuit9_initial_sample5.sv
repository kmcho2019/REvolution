module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    // Initialize q to 4 as per waveform initial known stable value when a=1
    initial begin
        q = 3'd4;
    end

    always @(posedge clk) begin
        if (a == 1'b1) begin
            q <= 3'd4;
        end else begin
            q <= q + 3'd1; // automatic wrap around mod 8 due to 3 bits
        end
    end

endmodule