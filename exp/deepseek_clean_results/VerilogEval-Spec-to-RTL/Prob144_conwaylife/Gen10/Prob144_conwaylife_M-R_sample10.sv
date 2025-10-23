module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic with direct neighbor calculation
    wire [255:0] next_q;

    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Calculate row and column indices
            wire [3:0] row = i[7:4];
            wire [3:0] col = i[3:0];
            
            // Compute neighbor positions with wrap-around
            wire [3:0] row_m1 = row - 4'b1;
            wire [3:0] row_p1 = row + 4'b1;
            wire [3:0] col_m1 = col - 4'b1;
            wire [3:0] col_p1 = col + 4'b1;
            
            // Get neighbor cell values
            wire n0 = q[{row_m1, col_m1}];
            wire n1 = q[{row_m1, col}];
            wire n2 = q[{row_m1, col_p1}];
            wire n3 = q[{row, col_m1}];
            wire n4 = q[{row, col_p1}];
            wire n5 = q[{row_p1, col_m1}];
            wire n6 = q[{row_p1, col}];
            wire n7 = q[{row_p1, col_p1}];
            
            // Count neighbors using adder tree
            wire [3:0] neighbor_count = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7;
            
            // Next state rules combined with stability check
            assign next_q[i] = (neighbor_count == 4'd3) ? 1'b1 :
                              (neighbor_count == 4'd2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // State update with load priority
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule