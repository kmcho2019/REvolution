module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;

    always @(*) begin
        // Left boundary (bit 0)
        case ({q[1], q[0], 1'b0})
            3'b111: next_q[0] = 0;
            3'b110: next_q[0] = 1;
            3'b101: next_q[0] = 1;
            3'b100: next_q[0] = 0;
            3'b011: next_q[0] = 1;
            3'b010: next_q[0] = 1;
            3'b001: next_q[0] = 1;
            3'b000: next_q[0] = 0;
        endcase

        // Internal bits (bits 1 to 510)
        for (i = 1; i < 511; i = i + 1) begin
            case ({q[i+1], q[i], q[i-1]})
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

        // Right boundary (bit 511)
        case ({1'b0, q[511], q[510]})
            3'b111: next_q[511] = 0;
            3'b110: next_q[511] = 1;
            3'b101: next_q[511] = 1;
            3'b100: next_q[511] = 0;
            3'b011: next_q[511] = 1;
            3'b010: next_q[511] = 1;
            3'b001: next_q[511] = 1;
            3'b000: next_q[511] = 0;
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule