module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [6:0] binary_count;

always @(posedge clk) begin
    if (reset) begin
        binary_count <= 7'd0;
    end else begin
        if (binary_count == 7'd9999) begin
            binary_count <= 7'd0;
        end else begin
            binary_count <= binary_count + 1;
        end
    end
end

// Combinational logic to convert binary to BCD
// and generate enable signals
wire [3:0] ones = binary_count[3:0];
wire [3:0] tens = binary_count[6:4];
assign q = {tens, ones};

// Enable signals based on the current count
assign ena[0] = (ones == 4'd9)? 1'b1 : 1'b0; // Ones place enable
assign ena[1] = (tens == 4'd9 && ones == 4'd9)? 1'b1 : 1'b0; // Tens place enable
assign ena[2] = (tens == 4'd9 && ones == 4'd9 && binary_count[6] == 1'b1)? 1'b1 : 1'b0; // Hundreds place enable

endmodule