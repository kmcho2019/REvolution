module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire clk_en = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else if (clk_en) begin
        if (load)
            q <= data;
        else // ena is high, load is low
            q <= {1'b0, q[3:1]};
    end
    // if clk_en is 0 and no reset, retain q value (no toggle)
end

endmodule