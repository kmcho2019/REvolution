module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Initialize q to 0 to avoid unknowns at startup
initial begin
    q = 4'b0000;
end

always @(*) begin
    if (shift_ena) begin
        // Shift right: insert 'data' at MSB, shift all bits toward LSB
        next_q = {data, q[3:1]};
    end
    else if (count_ena) begin
        next_q = q - 4'b0001;
    end
    else begin
        next_q = q;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule