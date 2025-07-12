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
    if (areset) begin
        q <= 4'b0;
    end else if (clk_en) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= q >> 1; // right shift by 1, MSB filled with zero
        end
    end
    // else: retain q to reduce toggling
end

endmodule