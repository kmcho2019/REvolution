module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial begin
    q = 3'd4;  // Initialize to 4 for simulation
end

always @(posedge clk) begin
    if (a) begin
        q <= q;  // hold value when a is high
    end else begin
        if (q == 3'd6) begin
            q <= 3'd0;  // wrap around after 6
        end else begin
            q <= q + 3'd1;  // increment when a is low
        end
    end
end

endmodule