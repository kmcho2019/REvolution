module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg prev_state;  // stores data_in from 2 cycles ago
reg curr_state;  // stores data_in from 1 cycle ago

// Output is high when we detect 010 pattern (rising then falling edge)
assign data_out = ~prev_state & curr_state & ~data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_state <= 1'b0;
        curr_state <= 1'b0;
    end
    else begin
        prev_state <= curr_state;
        curr_state <= data_in;
    end
end

endmodule