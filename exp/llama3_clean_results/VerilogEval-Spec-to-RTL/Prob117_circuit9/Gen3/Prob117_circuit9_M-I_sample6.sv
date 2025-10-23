module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @ (posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when 'a' is 1
    end else begin
        if (q == 7) begin
            q <= 0; // Wrap around to 0 when 'q' reaches 7
        end else if (q == 0 && a == 0) begin
            q <= 4; // if q is 0 and a is 0, set q to 4
        end else begin
            q <= q + 1; // Increment 'q' when 'a' is 0
        end
    end
end

initial begin
    q = 0; // Initialize 'q' to 0, let the first clock edge set it to 4 when 'a' is 1
end

endmodule