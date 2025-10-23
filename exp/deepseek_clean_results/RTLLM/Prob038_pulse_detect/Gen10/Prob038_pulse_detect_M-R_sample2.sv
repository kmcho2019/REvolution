module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [2:0] history_reg;

// Continuous assignment for shift operation
wire [2:0] history_next = {history_reg[1:0], data_in};

// Continuous assignment for output
assign data_out = (history_reg == 3'b010);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history_reg <= 3'b000;
    end
    else begin
        history_reg <= history_next;
    end
end

endmodule