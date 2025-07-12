module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b1) begin
        q <= 4;
    end else begin
        if (q == 3'b111) begin  // q is 7, wrap around to 0
            q <= 3'b000;
        end else if (q == 3'b000) begin  // q is 0, set to 1
            q <= 3'b001;
        end else begin  // increment q
            q <= q + 1;
        end
    end
end

endmodule