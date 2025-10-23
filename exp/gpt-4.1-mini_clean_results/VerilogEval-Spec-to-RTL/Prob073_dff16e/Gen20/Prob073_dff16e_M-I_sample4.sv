module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

// Separate upper and lower byte registers internally
reg [7:0] q_upper, q_lower;

always @(posedge clk) begin
    if (!resetn) begin
        q_upper <= 8'b0;
    end else if (byteena[1]) begin
        q_upper <= d[15:8];
    end
    // else retain q_upper
end

always @(posedge clk) begin
    if (!resetn) begin
        q_lower <= 8'b0;
    end else if (byteena[0]) begin
        q_lower <= d[7:0];
    end
    // else retain q_lower
end

always @* begin
    q = {q_upper, q_lower};
end

endmodule