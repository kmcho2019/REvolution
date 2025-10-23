module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

reg [7:0] upper_byte_q;
reg [7:0] lower_byte_q;

// Update upper byte register
always @(posedge clk) begin
    if (!resetn) begin
        upper_byte_q <= 8'b0;
    end else if (byteena[1]) begin
        upper_byte_q <= d[15:8];
    end
end

// Update lower byte register
always @(posedge clk) begin
    if (!resetn) begin
        lower_byte_q <= 8'b0;
    end else if (byteena[0]) begin
        lower_byte_q <= d[7:0];
    end
end

assign q = {upper_byte_q, lower_byte_q};

endmodule