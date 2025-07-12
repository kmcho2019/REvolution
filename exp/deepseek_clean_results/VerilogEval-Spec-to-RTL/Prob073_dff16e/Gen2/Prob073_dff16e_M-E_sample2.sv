module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

// Registered enable signals for better timing
reg [1:0] byteena_reg;
always @(posedge clk) begin
    if (!resetn) begin
        byteena_reg <= 2'b00;
    end else begin
        byteena_reg <= byteena;
    end
end

// Upper byte (bits 15:8)
reg [7:0] upper_byte;
always @(posedge clk) begin
    if (!resetn) begin
        upper_byte <= 8'b0;
    end else if (byteena_reg[1]) begin
        upper_byte <= d[15:8];
    end
end

// Lower byte (bits 7:0)
reg [7:0] lower_byte;
always @(posedge clk) begin
    if (!resetn) begin
        lower_byte <= 8'b0;
    end else if (byteena_reg[0]) begin
        lower_byte <= d[7:0];
    end
end

// Output assignment
assign q = {upper_byte, lower_byte};

endmodule