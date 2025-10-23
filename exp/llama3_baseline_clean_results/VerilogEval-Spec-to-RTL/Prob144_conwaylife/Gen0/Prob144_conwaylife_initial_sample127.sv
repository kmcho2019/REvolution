module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    reg [255:0] q_reg;

    always @(posedge clk) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= calculate_next_state(q_reg);
        end
    end

    assign q = q_reg;

    function [255:0] calculate_next_state;
        input [255:0] current_state;
        reg [255:0] next_state;

        integer i, j;
        reg [2:0] neighbors;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbors = count_neighbors(current_state, i, j);
                if (neighbors == 2'b10 || neighbors == 2'b00 || neighbors > 3) begin
                    next_state[(i * 16) + j] = 1'b0;
                end else if (neighbors == 3) begin
                    next_state[(i * 16) + j] = 1'b1;
                end else begin
                    next_state[(i * 16) + j] = current_state[(i * 16) + j];
                end
            end
        end

        calculate_next_state = next_state;
    endfunction

    function [2:0] count_neighbors;
        input [255:0] current_state;
        input [3:0] i;
        input [3:0] j;
        reg [2:0] neighbors;

        neighbors = 3'b000;

        for (int x = -1; x <= 1; x = x + 1) begin
            for (int y = -1; y <= 1; y = y + 1) begin
                if (x == 0 && y == 0) begin
                    continue;
                end

                integer idx;
                integer ii = (i + x + 16) % 16;
                integer jj = (j + y + 16) % 16;

                idx = (ii * 16) + jj;

                if (current_state[idx]) begin
                    neighbors = neighbors + 1'b1;
                end
            end
        end

        count_neighbors = neighbors;
    endfunction

endmodule