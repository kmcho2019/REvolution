module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] q_int;

always_ff @(posedge clk) begin
    if (reset) begin
        q_int <= 8'd0;
    end else begin
        q_int[0] <= d[0];
        q_int[1] <= d[1];
        q_int[2] <= d[2];
        q_int[3] <= d[3];
        q_int[4] <= d[4];
        q_int[5] <= d[5];
        q_int[6] <= d[6];
        q_int[7] <= d[7];
    end
end

assign q = q_int;

endmodule