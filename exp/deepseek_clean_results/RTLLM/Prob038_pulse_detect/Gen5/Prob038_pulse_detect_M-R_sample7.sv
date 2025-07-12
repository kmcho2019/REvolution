module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [2:0] history;

// Shift register implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 3'b000;
    end else begin
        history[0] <= data_in;
        history[1] <= history[0];
        history[2] <= history[1];
    end
end

// Continuous output assignment
assign data_out = (history == 3'b010);

endmodule