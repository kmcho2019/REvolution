module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  [15:0]  q
);

    reg [7:0] q_lower;
    reg [7:0] q_upper;

    // Lower byte register
    always @(posedge clk) begin
        if (!resetn) begin
            q_lower <= 8'b0;
        end else if (byteena[0]) begin
            q_lower <= d[7:0];
        end
        // else keep old value
    end

    // Upper byte register
    always @(posedge clk) begin
        if (!resetn) begin
            q_upper <= 8'b0;
        end else if (byteena[1]) begin
            q_upper <= d[15:8];
        end
        // else keep old value
    end

    // Concatenate to form output
    assign q = {q_upper, q_lower};

endmodule