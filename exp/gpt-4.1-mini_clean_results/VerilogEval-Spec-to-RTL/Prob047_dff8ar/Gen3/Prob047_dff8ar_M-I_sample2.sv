module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output reg [7:0] q
);

    wire update = areset | (d != q);

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else if (update)
            q <= d;
        else
            q <= q; // retain current value to avoid unnecessary toggling
    end
endmodule