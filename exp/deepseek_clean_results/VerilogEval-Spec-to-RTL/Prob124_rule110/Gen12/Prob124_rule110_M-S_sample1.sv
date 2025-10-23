module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Handle left boundary (i=0)
            q[0] <= ~(q[0] & q[1]) | (q[1] & ~q[0]);

            // Handle middle cells (i=1 to 510)
            for (integer i = 1; i < 511; i = i + 1) begin
                case ({q[i+1], q[i], q[i-1]})
                    3'b111: q[i] <= 0;
                    3'b110: q[i] <= 1;
                    3'b101: q[i] <= 1;
                    3'b100: q[i] <= 0;
                    3'b011: q[i] <= 1;
                    3'b010: q[i] <= 1;
                    3'b001: q[i] <= 1;
                    3'b000: q[i] <= 0;
                endcase
            end

            // Handle right boundary (i=511)
            q[511] <= (q[510] & ~q[511]) | (~q[510] & q[511]);
        end
    end

endmodule