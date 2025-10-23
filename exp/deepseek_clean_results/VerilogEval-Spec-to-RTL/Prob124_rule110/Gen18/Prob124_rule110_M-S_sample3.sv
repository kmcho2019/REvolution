module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Get neighbors with boundary conditions
            reg left, right;
            left = (i == 511) ? 1'b0 : q[i+1];
            right = (i == 0) ? 1'b0 : q[i-1];

            // Direct implementation of Rule 110 truth table
            case ({left, q[i], right})
                3'b111: next_q[i] = 0;
                3'b110: next_q[i] = 1;
                3'b101: next_q[i] = 1;
                3'b100: next_q[i] = 0;
                3'b011: next_q[i] = 1;
                3'b010: next_q[i] = 1;
                3'b001: next_q[i] = 1;
                3'b000: next_q[i] = 0;
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule