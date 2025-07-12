module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// State register (0-9)
reg [3:0] state;

// ROM containing the count sequence
wire [3:0] rom [0:9];
assign rom[0] = 4'b0000;
assign rom[1] = 4'b0001;
assign rom[2] = 4'b0010;
assign rom[3] = 4'b0011;
assign rom[4] = 4'b0100;
assign rom[5] = 4'b0101;
assign rom[6] = 4'b0110;
assign rom[7] = 4'b0111;
assign rom[8] = 4'b1000;
assign rom[9] = 4'b1001;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end
    else if (slowena) begin
        state <= (state == 4'b1001) ? 4'b0000 : state + 1'b1;
    end
end

// Output is always the current ROM value
always @(*) begin
    q = rom[state];
end

endmodule