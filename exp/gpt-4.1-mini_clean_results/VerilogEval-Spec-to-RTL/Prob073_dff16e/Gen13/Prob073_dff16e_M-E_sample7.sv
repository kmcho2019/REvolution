module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  [15:0]  q
);

    reg [7:0] q_upper;
    reg [7:0] q_lower;

    // Upper byte flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            q_upper <= 8'b0;
        else if (byteena[1])
            q_upper <= d[15:8];
    end

    // Lower byte flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            q_lower <= 8'b0;
        else if (byteena[0])
            q_lower <= d[7:0];
    end

    // Concatenate upper and lower byte registers to form output q
    assign q = {q_upper, q_lower};

endmodule