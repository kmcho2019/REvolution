module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [2:0] binary_counter;
reg [6:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        binary_counter <= 'd0;
        lfsr <= 'd1;
    end else begin
        if (binary_counter == 3'd7) begin
            binary_counter <= 'd0;
            lfsr <= {lfsr[5:0], lfsr[6] ^ lfsr[5]};
        end else begin
            binary_counter <= binary_counter + 1'b1;
        end
    end
end

assign q = {lfsr, binary_counter};

endmodule