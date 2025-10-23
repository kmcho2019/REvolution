module TopModule(
    input clk,
    input logic [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 8'd0; // Reset q to 0 when rst_n is low
    end else begin
        q <= d; // Assign d to q on the positive edge of clk when rst_n is high
    end
end

endmodule