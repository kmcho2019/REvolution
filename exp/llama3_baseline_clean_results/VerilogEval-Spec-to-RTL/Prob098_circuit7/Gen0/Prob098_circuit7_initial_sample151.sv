module TopModule(
    input clk,
    input a,
    output reg q
);

reg init = 1'b0; // Flag to track the first positive clock edge

always @(posedge clk) begin
    if (!init) begin // First positive clock edge encountered
        q <= 1'b1;
        init <= 1'b1;
    end else if (a) begin // If a is high, toggle q
        q <= ~q;
    end
end

endmodule