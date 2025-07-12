module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    // Lower byte flip-flops
    always @(posedge clk) begin
        if (!resetn)
            q[7:0] <= 8'b0;
        else if (byteena[0])
            q[7:0] <= d[7:0];
        else
            q[7:0] <= q[7:0];  // Retain previous value
    end

    // Upper byte flip-flops
    always @(posedge clk) begin
        if (!resetn)
            q[15:8] <= 8'b0;
        else if (byteena[1])
            q[15:8] <= d[15:8];
        else
            q[15:8] <= q[15:8]; // Retain previous value
    end

endmodule