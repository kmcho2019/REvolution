module TopModule(
    input clk,
    input rst_n, // Added reset input for initialization
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        prev_in <= 8'b0;
        anyedge_reg <= 8'b0;
    end else begin
        prev_in <= in;
        anyedge_reg <= (prev_in ^ in);
    end
end

assign anyedge = anyedge_reg;

endmodule