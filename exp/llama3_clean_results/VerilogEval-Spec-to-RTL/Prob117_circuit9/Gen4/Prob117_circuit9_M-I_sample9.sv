module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        // Do nothing if a is high and q is already 4
        if (q!= 4) begin
            q <= 4;
        end
    end else begin
        if (q == 6) begin
            q <= 0;
        end else if (q!= 6) begin
            q <= q + 1;
        end
    end
end

// Explicitly define the reset condition
initial begin
    q <= 0; // Reset value, should be adjusted according to the specific requirements
end

endmodule