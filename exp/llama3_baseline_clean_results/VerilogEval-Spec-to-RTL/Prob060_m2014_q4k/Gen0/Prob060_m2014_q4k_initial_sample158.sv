module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] dff_out;

always @(posedge clk) begin
    if (!resetn) begin
        dff_out <= 4'd0;
    end else begin
        dff_out <= {dff_out[2:0], in};
    end
end

assign out = dff_out[3];

endmodule