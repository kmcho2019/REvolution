module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Gated clock enable: updates occur only when load or ena is asserted
wire gated_clk_en = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else if (gated_clk_en) begin
        if (load)
            q <= data;
        else // ena is true here (load|ena) and load==0
            q <= {1'b0, q[3:1]};
    end
    // else retain q without toggling to reduce switching
end

endmodule