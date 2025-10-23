module TopModule(
    input  d,
    input  ena,
    output q
);
wire q_internal;
assign q = q_internal;

always @(d or ena) begin
    if (ena) begin
        q_internal <= d; 
    end 
end

endmodule