module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire write_enable = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else if (write_enable) begin
        if (load)
            q <= data;
        else // ena == 1 and load == 0
            q <= {1'b0, q[3:1]};
    end
end

endmodule