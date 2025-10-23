module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the LFSR characteristic polynomial
reg [3:0] lfsr;

// LFSR next state logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        lfsr <= 4'b1001;
    end else begin
        // XNOR feedback for the LFSR
        lfsr <= {lfsr[2:0], ~(lfsr[3] ^ lfsr[0])};
    end
end

// Comparator logic
reg sequence_match;
always @(posedge clk) begin
    sequence_match <= (lfsr == 4'b1001);
end

// Output logic
assign sequence_detected = sequence_match;

endmodule