module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    input data_valid,  // New signal for clock gating
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire pattern_match;

// Clock gating: only shift when new data is valid
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end
    else if (data_valid) begin  // Only shift when data is valid
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Pattern matching combinational logic
assign pattern_match = shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0];

// Register output to break critical path
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sequence_detected <= 1'b0;
    end
    else begin
        sequence_detected <= pattern_match;
    end
end

endmodule