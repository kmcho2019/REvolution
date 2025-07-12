module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pre-computed constant neighbor indices
    function [7:0][3:0] get_neighbor_indices;
        input [7:0] idx;
        reg [3:0] row, col;
        begin
            row = idx[7:4];
            col = idx[3:0];
            // Calculate neighbor positions with optimized wrap-around using masking
            get_neighbor_indices[0] = {(row - 4'd1) & 4'hF, (col - 4'd1) & 4'hF}; // NW
            get_neighbor_indices[1] = {(row - 4'd1) & 4'hF, col};                  // N
            get_neighbor_indices[2] = {(row - 4'd1) & 4'hF, (col + 4'd1) & 4'hF};  // NE
            get_neighbor_indices[3] = {row, (col - 4'd1) & 4'hF};                  // W
            get_neighbor_indices[4] = {row, (col + 4'd1) & 4'hF};                  // E
            get_neighbor_indices[5] = {(row + 4'd1) & 4'hF, (col - 4'd1) & 4'hF};  // SW
            get_neighbor_indices[6] = {(row + 4'd1) & 4'hF, col};                 // S
            get_neighbor_indices[7] = {(row + 4'd1) & 4'hF, (col + 4'd1) & 4'hF}; // SE
        end
    endfunction

    // Next state logic with optimized counting
    wire [255:0] next_q;
    
    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Only compute neighbor count when not loading
            wire [3:0] neighbor_count;
            wire compute = ~load;
            
            // Optimized 4+4 neighbor counting
            wire [1:0] sum_a = compute ? (q[get_neighbor_indices(i)[0]] + q[get_neighbor_indices(i)[1]] + 
                                         q[get_neighbor_indices(i)[2]] + q[get_neighbor_indices(i)[3]]) : 2'b0;
            wire [1:0] sum_b = compute ? (q[get_neighbor_indices(i)[4]] + q[get_neighbor_indices(i)[5]] + 
                                         q[get_neighbor_indices(i)[6]] + q[get_neighbor_indices(i)[7]]) : 2'b0;
            
            assign neighbor_count = sum_a + sum_b;
            
            // Next state rules
            assign next_q[i] = (neighbor_count == 4'd3) ? 1'b1 :
                              (neighbor_count == 4'd2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Optimized state update with combined load/update logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule