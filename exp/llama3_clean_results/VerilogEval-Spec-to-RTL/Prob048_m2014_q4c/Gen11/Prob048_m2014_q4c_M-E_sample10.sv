module TopModule(
    input  logic clk,
    input  logic d,
    input  logic r,
    output logic q
);

logic intermediate_state;

always @(posedge clk) begin
    if (r) begin
        intermediate_state <= 1'b0;
    end else begin
        intermediate_state <= d;
    end
end

always @(posedge clk) begin
    q <= intermediate_state;
end

endmodule