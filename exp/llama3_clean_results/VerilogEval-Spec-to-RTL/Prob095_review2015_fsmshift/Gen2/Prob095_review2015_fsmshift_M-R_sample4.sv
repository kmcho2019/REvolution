module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] shift_ena_asserted;
reg reset_detected;

// sequential logic
always @(posedge clk) begin
    if (reset) begin
        shift_ena_asserted = 0;
        reset_detected = 1'b1;
    end
    else if (reset_detected && shift_ena_asserted < 4) begin
        shift_ena_asserted = shift_ena_asserted + 1;
    end
    else if (reset_detected && shift_ena_asserted == 4) begin
        reset_detected = 1'b0;
    end
end

// continuous assignment
assign shift_ena = reset_detected;

endmodule