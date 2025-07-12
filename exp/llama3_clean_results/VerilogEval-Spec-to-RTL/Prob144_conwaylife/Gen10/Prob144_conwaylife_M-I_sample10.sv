module RowModule(
    input [15:0] current_row,
    input [15:0] above_row,
    input [15:0] below_row,
    output reg [15:0] next_row
);

integer col;

always @(*) begin
    for (col = 0; col < 16; col++) begin
        reg [3:0] neighbor_count = 0;
        
        // Count neighbors
        for (integer i = -1; i <= 1; i++) begin
            for (integer j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) begin
                    continue;
                end
                integer new_col = (col + j + 16) % 16;
                integer new_row;
                if (i == -1) begin
                    new_row = above_row;
                end else if (i == 0) begin
                    new_row = current_row;
                end else begin
                    new_row = below_row;
                end
                
                if (new_row[new_col]) begin
                    neighbor_count = neighbor_count + 1;
                end
            end
        end
        
        // Update next state based on neighbor count
        case (neighbor_count)
            0, 1: next_row[col] = 1'b0;
            2: next_row[col] = current_row[col];
            3: next_row[col] = 1'b1;
            default: next_row[col] = 1'b0;
        endcase
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [15:0] rows[15:0];
reg [15:0] next_rows[15:0];

RowModule row_modules[15:0] (
    .current_row(rows),
    .above_row({rows[15], rows[14:0]}),
    .below_row({rows[1:15], rows[0]}),
    .next_row(next_rows)
);

always @(posedge clk) begin
    if (load) begin
        for (integer row = 0; row < 16; row++) begin
            rows[row] <= data[(row*16 +: 16)];
        end
    end else begin
        for (integer row = 0; row < 16; row++) begin
            rows[row] <= next_rows[row];
        end
    end
    
    // Update grid and output
    for (integer row = 0; row < 16; row++) begin
        q[(row*16 +: 16)] <= rows[row];
    end
end

endmodule