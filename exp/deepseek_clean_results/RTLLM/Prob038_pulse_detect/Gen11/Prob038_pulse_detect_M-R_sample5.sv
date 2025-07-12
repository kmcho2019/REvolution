module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [2:0] history;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 3'b000;
    end
    else begin
        history <= {history[1:0], data_in};
    end
end

assign data_out = (history == 3'b010);

endmodule