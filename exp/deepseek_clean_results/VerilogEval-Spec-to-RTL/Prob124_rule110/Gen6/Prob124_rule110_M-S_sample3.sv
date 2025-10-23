module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] extended_q = {1'b0, q, 1'b0};  // Virtual boundary bits
    reg [511:0] next_q;

    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            case ({extended_q[i+2], extended_q[i+1], extended_q[i]})
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
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule