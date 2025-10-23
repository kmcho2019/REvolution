module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] current_state;
reg [31:0] output_state;

always @ (posedge clk) begin
    if (reset) begin
        output_state <= 32'd0;
        current_state <= 32'd0;
    end else begin
        current_state <= in;
        output_state <= output_state | (~in & current_state);
    end
end

assign out = output_state;

endmodule