module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, j;
    integer row_prev, row_next, col_prev, col_next;
    integer neighbor_count;

    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate neighbor positions with modulo wrap-around
                row_prev = (i == 0) ? 15 : (i - 1);
                row_next = (i == 15) ? 0 : (i + 1);
                col_prev = (j == 0) ? 15 : (j - 1);
                col_next = (j == 15) ? 0 : (j + 1);

                // Count live neighbors
                neighbor_count = 
                    q[row_prev*16 + col_prev] + q[row_prev*16 + j] + q[row_prev*16 + col_next] +
                    q[i*16 + col_prev] + q[i*16 + col_next] +
                    q[row_next*16 + col_prev] + q[row_next*16 + j] + q[row_next*16 + col_next];

                // Calculate next state
                case (neighbor_count)
                    3: next_q[i*16 + j] = 1'b1;
                    2: next_q[i*16 + j] = q[i*16 + j];
                    default: next_q[i*16 + j] = 1'b0;
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