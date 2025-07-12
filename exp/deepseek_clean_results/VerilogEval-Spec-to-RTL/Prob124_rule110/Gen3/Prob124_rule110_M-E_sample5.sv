module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    wire left_bound = 1'b0;  // q[-1]
    wire right_bound = 1'b0; // q[512]

    always @(*) begin
        // Left boundary cell (i=0)
        case ({left_bound, q[0], q[1]})
            3'b111: next_q[0] = 1'b0;
            3'b110: next_q[0] = 1'b1;
            3'b101: next_q[0] = 1'b1;
            3'b100: next_q[0] = 1'b0;
            3'b011: next_q[0] = 1'b1;
            3'b010: next_q[0] = 1'b1;
            3'b001: next_q[0] = 1'b1;
            3'b000: next_q[0] = 1'b0;
        endcase

        // Middle cells (i=1 to 510)
        for (integer i = 1; i < 511; i = i + 1) begin
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

        // Right boundary cell (i=511)
        case ({q[510], q[511], right_bound})
            3'b111: next_q[511] = 1'b0;
            3'b110: next_q[511] = 1'b1;
            3'b101: next_q[511] = 1'b1;
            3'b100: next_q[511] = 1'b0;
            3'b011: next_q[511] = 1'b1;
            3'b010: next_q[511] = 1'b1;
            3'b001: next_q[511] = 1'b1;
            3'b000: next_q[511] = 1'b0;
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