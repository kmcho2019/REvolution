module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

    reg [255:0] state;

    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= calculate_next_state(state);
        end
    end

    assign q = state;

    function [255:0] calculate_next_state;
        input [255:0] state;
        reg [255:0] next_state;
        integer i, j;

        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = calculate_neighbors(state, i, j);
                case (neighbors)
                    3'b001, 3'b100: next_state[(i * 16) + j] = 1'b1;
                    3'b010: next_state[(i * 16) + j] = state[(i * 16) + j];
                    default: next_state[(i * 16) + j] = 1'b0;
                endcase
            end
        end
        calculate_next_state = next_state;
    endfunction

    function [2:0] calculate_neighbors;
        input [255:0] state;
        input [3:0] i;
        input [3:0] j;
        reg [2:0] neighbors;

        neighbors = 0;

        // Calculate the neighbors
        for (integer x = -1; x <= 1; x++) begin
            for (integer y = -1; y <= 1; y++) begin
                if ((x == 0) && (y == 0)) begin
                    // Don't count the cell itself
                    continue;
                end
                integer ii = (i + x + 16) % 16;
                integer jj = (j + y + 16) % 16;
                neighbors += state[(ii * 16) + jj];
            end
        end

        calculate_neighbors = neighbors;
    endfunction

endmodule