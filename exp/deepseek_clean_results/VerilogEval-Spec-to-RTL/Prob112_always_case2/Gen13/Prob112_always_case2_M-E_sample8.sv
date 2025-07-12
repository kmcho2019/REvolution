module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    // Check lower 2 bits first
    if (|in[1:0]) begin
        if (in[0]) pos = 2'b00;
        else if (in[1]) pos = 2'b01;
    end
    // Only check upper bits if lower bits are all 0
    else if (|in[3:2]) begin
        if (in[2]) pos = 2'b10;
        else if (in[3]) pos = 2'b11;
    end
    // Default case when all inputs are 0
    else begin
        pos = 2'b00;
    end
end

endmodule