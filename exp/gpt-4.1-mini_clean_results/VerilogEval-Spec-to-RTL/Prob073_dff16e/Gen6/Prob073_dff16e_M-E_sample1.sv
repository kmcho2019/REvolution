module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

    // Lower byte register
    reg [7:0] q_low;
    // Upper byte register
    reg [7:0] q_high;

    always @(posedge clk) begin
        if (!resetn) begin
            q_low  <= 8'b0;
        end else if (byteena[0]) begin
            q_low  <= d[7:0];
        end
        // else hold value
    end

    always @(posedge clk) begin
        if (!resetn) begin
            q_high <= 8'b0;
        end else if (byteena[1]) begin
            q_high <= d[15:8];
        end
        // else hold value
    end

    always @(*) begin
        q = {q_high, q_low};
    end

endmodule