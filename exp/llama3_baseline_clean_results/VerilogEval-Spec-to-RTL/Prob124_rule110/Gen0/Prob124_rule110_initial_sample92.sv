module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @ (posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            wire left, center, right;
            if (i == 0) begin
                left = 0;
            end else begin
                left = q[i-1];
            end
            center = q[i];
            if (i == 511) begin
                right = 0;
            end else begin
                right = q[i+1];
            end
            q[i] <= ~(left & center & ~right) && ~(~left & ~center & ~right) && ~(left & ~center & ~right) && ~(left & ~center & right) && ~(~left & center & ~right);
            // simplified equation
            q[i] <= ~(left & center & ~right) && (left & ~center & ~right) || (left & ~center & right) || (~left & center & right) || (~left & center & ~right);
        end
    end
end

endmodule