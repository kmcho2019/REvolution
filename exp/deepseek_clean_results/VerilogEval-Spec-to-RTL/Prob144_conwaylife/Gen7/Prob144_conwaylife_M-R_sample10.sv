module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] wrap_around(input [3:0] val);
        wrap_around = val; // Automatic wrap-around with 4-bit arithmetic
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    // Calculate neighbor positions with wrap-around
                    wire [3:0] row = i;
                    wire [3:0] col = j;
                    wire [3:0] row_m1 = wrap_around(row - 1);
                    wire [3:0] row_p1 = wrap_around(row + 1);
                    wire [3:0] col_m1 = wrap_around(col - 1);
                    wire [3:0] col_p1 = wrap_around(col + 1);

                    // Count live neighbors
                    reg [3:0] count = 0;
                    count = count + q[{row_m1, col_m1}];
                    count = count + q[{row_m1, col}];
                    count = count + q[{row_m1, col_p1}];
                    count = count + q[{row, col_m1}];
                    count = count + q[{row, col_p1}];
                    count = count + q[{row_p1, col_m1}];
                    count = count + q[{row_p1, col}];
                    count = count + q[{row_p1, col_p1}];

                    // Update cell state based on neighbor count
                    case (count)
                        4'd3: q[{row,col}] <= 1'b1;
                        4'd2: q[{row,col}] <= q[{row,col}];
                        default: q[{row,col}] <= 1'b0;
                    endcase
                end
            end
        end
    end

endmodule