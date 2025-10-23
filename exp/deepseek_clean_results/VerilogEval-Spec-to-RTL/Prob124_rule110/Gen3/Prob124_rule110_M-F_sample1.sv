module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        // Handle leftmost cell (i=0)
        next_q[0] = (q[0] & q[1]) ? 1'b0 :  // 111 or 011 -> 0
                    (q[0] & ~q[1]) ? 1'b1 :  // 110 or 010 -> 1
                    (~q[0] & q[1]) ? 1'b1 :  // 101 or 001 -> 1
                    1'b0;                    // 100 or 000 -> 0

        // Handle middle cells (i=1 to 510)
        for (integer i = 1; i < 511; i = i+1) begin
            case ({q[i-1], q[i], q[i+1]})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
            endcase
        end

        // Handle rightmost cell (i=511)
        next_q[511] = (q[510] & q[511]) ? 1'b0 :  // 111 or 110 -> 0
                      (q[510] & ~q[511]) ? 1'b1 : // 101 or 100 -> 1
                      (~q[510] & q[511]) ? 1'b1 : // 011 or 010 -> 1
                      1'b0;                       // 001 or 000 -> 0
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule