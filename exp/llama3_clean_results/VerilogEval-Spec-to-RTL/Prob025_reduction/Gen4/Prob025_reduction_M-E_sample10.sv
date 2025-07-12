module TopModule(
    input clk,  // Clock signal
    input [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

reg [2:0] counter;  // Counter to iterate through input bits
reg [7:0] temp_in;  // Temporary storage for input

always @ (posedge clk) begin
    if (counter == 0) begin
        temp_in <= in;
        parity <= 1'b0;
        counter <= counter + 1;
    end else if (counter < 8) begin
        parity <= parity ^ temp_in[7 - counter + 1];
        counter <= counter + 1;
    end else begin
        counter <= 0;
    end
end

endmodule