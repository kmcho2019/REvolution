module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Internal signals
logic [7:0] shift_reg;

// Initial value for shift register
initial shift_reg = 8'b0;

always_ff @(posedge clk) begin
    if (reset) begin
        // Synchronous reset
        shift_reg <= 8'b0;
    end else begin
        // Shift in new data from d
        shift_reg <= {d[6:0], d[7]};
    end
end

// Assign output q from shift register
assign q = shift_reg;

endmodule