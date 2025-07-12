module TopModule(
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Generate gated clock enable signal
wire clk_en = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;
    else if (clk_en) begin
        if (load)
            q <= data;
        else // ena only
            q <= {1'b0, q[3:1]};
    end
    // If clk_en == 0, hold q
end

endmodule