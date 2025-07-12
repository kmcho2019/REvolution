module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

reg [3:0] dff_out;

always @(posedge clk) begin
    if (!resetn) begin
        dff_out <= 4'b0000;
    end else begin
        dff_out <= {in, dff_out[3:1]};
    end
end

assign out = dff_out[0];

endmodule