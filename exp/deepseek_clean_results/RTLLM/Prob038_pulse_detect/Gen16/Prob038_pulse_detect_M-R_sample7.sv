module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Track previous two samples (2-bit register for 3-cycle detection)
reg [1:0] history;

// Sequential part: update history register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 2'b00;
    end
    else begin
        history <= {history[0], data_in};
    end
end

// Combinational part: detect 010 pattern
assign data_out = (history == 2'b10) && (data_in == 1'b0);

endmodule