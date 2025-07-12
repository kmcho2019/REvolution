module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Internal clock enable signal to reduce unnecessary register toggling
wire clk_en = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else if (clk_en) begin
        if (load) begin
            q <= data;
        end else begin
            q <= {1'b0, q[3:1]};
        end
    end
    // if clk_en is low, retain q (no update)
end

endmodule