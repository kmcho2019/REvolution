module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] dff;

always @(posedge clk) begin
    if (!resetn) begin
        dff <= 4'b0000;
    end else begin
        dff <= {in, dff[3:1]};
    end
end

assign out = dff[0];

endmodule