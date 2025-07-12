module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    reg [15:0] q_next;

    always @(*) begin
        // Default next value is current value
        q_next = q;
        if (!resetn) begin
            q_next = 16'b0;
        end else begin
            if (byteena[1])
                q_next[15:8] = d[15:8];
            if (byteena[0])
                q_next[7:0] = d[7:0];
        end
    end

    always @(posedge clk) begin
        q <= q_next;
    end

endmodule