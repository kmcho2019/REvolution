module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] wrap_add(input [3:0] a, input [3:0] b);
        wrap_add = a + b;
    endfunction

    function [3:0] wrap_sub(input [3:0] a, input [3:0] b);
        wrap_sub = a - b;
    endfunction

    function [7:0] get_neighbor_pos(input [7:0] idx, input [2:0] dir);
        reg [3:0] row, col;
        row = idx[7:4];
        col = idx[3:0];
        
        case(dir)
            0: begin // top-left
                row = wrap_sub(row, 1);
                col = wrap_sub(col, 1);
            end
            1: begin // top
                row = wrap_sub(row, 1);
            end
            2: begin // top-right
                row = wrap_sub(row, 1);
                col = wrap_add(col, 1);
            end
            3: begin // left
                col = wrap_sub(col, 1);
            end
            4: begin // right
                col = wrap_add(col, 1);
            end
            5: begin // bottom-left
                row = wrap_add(row, 1);
                col = wrap_sub(col, 1);
            end
            6: begin // bottom
                row = wrap_add(row, 1);
            end
            7: begin // bottom-right
                row = wrap_add(row, 1);
                col = wrap_add(col, 1);
            end
        endcase
        
        get_neighbor_pos = {row, col};
    endfunction

    wire [255:0] next_q;
    integer i, j;
    reg [3:0] neighbor_count;

    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            neighbor_count = 0;
            for (j = 0; j < 8; j = j + 1) begin
                neighbor_count = neighbor_count + q[get_neighbor_pos(i, j)];
            end
            
            case(neighbor_count)
                4'd0, 4'd1: next_q[i] = 1'b0;
                4'd2: next_q[i] = q[i];
                4'd3: next_q[i] = 1'b1;
                default: next_q[i] = 1'b0;
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