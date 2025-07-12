module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire clk_posedge;
reg q_internal;
reg prev_clk;

// Detect positive edge of clock
assign clk_posedge = clk & ~prev_clk;

always @* begin
    if (ar)
        q_internal = 1'b0;
    else if (clk_posedge)
        q_internal = d;
end

always @(posedge clk or posedge ar)
    prev_clk <= clk;

assign q = q_internal;

endmodule