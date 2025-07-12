module TopModule(
    input  logic clk,
    input  logic d,
    input  logic r,
    output logic q
);

logic q_next;

always @(posedge clk) begin
    if (r) begin
        q_next <= 1'b0;
    end else begin
        q_next <= d;
    end
end

assign q = q_next;

endmodule