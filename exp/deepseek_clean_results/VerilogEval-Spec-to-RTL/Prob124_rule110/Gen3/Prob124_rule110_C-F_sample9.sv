module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    wire [511:0] left_neighbor = {1'b0, q[511:1]};
    wire [511:0] right_neighbor = {q[510:0], 1'b0};

    always @(*) begin
        if (!load) begin
            for (integer i = 0; i < 512; i = i + 1) begin
                case ({left_neighbor[i], q[i], right_neighbor[i]})
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
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule