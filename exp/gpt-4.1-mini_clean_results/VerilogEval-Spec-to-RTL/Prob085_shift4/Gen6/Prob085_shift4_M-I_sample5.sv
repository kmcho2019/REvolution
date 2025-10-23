module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire enable_reg = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else if (enable_reg) begin
        if (load) 
            q <= data;
        else // ena must be high here
            q <= {1'b0, q[3:1]};
    end
    // else retain q (no update)
end

endmodule