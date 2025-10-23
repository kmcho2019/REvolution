module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Efficient wrap-around using conditional expressions
                wire [3:0] row_prev = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_next = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_prev = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_next = (j == 15) ? 0 : (j + 1);
                
                // Neighbor indices using shifts instead of multiplication
                wire [7:0] n0 = {row_prev, col_prev};
                wire [7:0] n1 = {row_prev, j};
                wire [7:0] n2 = {row_prev, col_next};
                wire [7:0] n3 = {i, col_prev};
                wire [7:0] n4 = {i, col_next};
                wire [7:0] n5 = {row_next, col_prev};
                wire [7:0] n6 = {row_next, j};
                wire [7:0] n7 = {row_next, col_next};
                
                // Optimized neighbor counting (2-level adder tree)
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2]; // Top row (3 neighbors)
                wire [1:0] sum_bottom = q[n5] + q[n6] + q[n7]; // Bottom row (3 neighbors)
                wire [1:0] sum_middle = q[n3] + q[n4]; // Middle row (2 neighbors)
                wire [3:0] neighbor_count = sum_top + sum_bottom + sum_middle;
                
                // Combined state transition and stability detection
                wire will_change = (neighbor_count != 2);
                wire new_state = (neighbor_count == 3) ? 1'b1 : 1'b0;
                assign next_q[i*16+j] = will_change ? new_state : q[i*16+j];
            end
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule