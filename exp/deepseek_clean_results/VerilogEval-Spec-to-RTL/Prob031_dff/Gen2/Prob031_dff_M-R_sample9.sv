module TopModule (
    input clk,
    input d,
    output reg q
);

wire q_next = (clk && !$past(clk)) ? d : q;

always @* begin
    q = q_next;
end

endmodule