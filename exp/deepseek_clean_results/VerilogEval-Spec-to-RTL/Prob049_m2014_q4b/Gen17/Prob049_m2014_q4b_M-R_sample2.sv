module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;

// Continuous assignment for the output
assign q = q_reg;

// Clock and reset behavior implemented with continuous assignments
wire clk_posedge = clk & ~$past(clk);
wire reset_condition = ar;
wire update_condition = clk_posedge & ~ar;

always @* begin
    if (reset_condition)
        q_reg = 1'b0;
    else if (update_condition)
        q_reg = d;
    // else retain value (implicit)
end

endmodule