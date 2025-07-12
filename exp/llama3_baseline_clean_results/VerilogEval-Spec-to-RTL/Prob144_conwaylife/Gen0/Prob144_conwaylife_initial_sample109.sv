module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    reg [255:0] q_reg;

    integer i, j, x, y, neighbours;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= next_q;
        end
    end

    always @(*) begin
        next_q = q_reg;
        for (i = 0; i < 256; i = i + 1) begin
            x = i % 16;
            y = i / 16;
            neighbours = 0;
            for (j = 0; j < 8; j = j + 1) begin
                case (j)
                    0: begin
                        if (q_reg[((((y - 1) % 16) * 16) + ((x - 1) % 16))]) neighbours = neighbours + 1;
                    end
                    1: begin
                        if (q_reg[((((y - 1) % 16) * 16) + (x)]) neighbours = neighbours + 1;
                    end
                    2: begin
                        if (q_reg[((((y - 1) % 16) * 16) + ((x + 1) % 16))]) neighbours = neighbours + 1;
                    end
                    3: begin
                        if (q_reg[((((y) % 16) * 16) + ((x - 1) % 16))]) neighbours = neighbours + 1;
                    end
                    4: begin
                        if (q_reg[((((y) % 16) * 16) + ((x + 1) % 16))]) neighbours = neighbours + 1;
                    end
                    5: begin
                        if (q_reg[((((y + 1) % 16) * 16) + ((x - 1) % 16))]) neighbours = neighbours + 1;
                    end
                    6: begin
                        if (q_reg[((((y + 1) % 16) * 16) + (x))]) neighbours = neighbours + 1;
                    end
                    7: begin
                        if (q_reg[((((y + 1) % 16) * 16) + ((x + 1) % 16))]) neighbours = neighbours + 1;
                    end
                endcase
            end
            if ((q_reg[i] == 1'b1 && (neighbours < 2 || neighbours > 3)) || (q_reg[i] == 1'b0 && neighbours == 3)) begin
                next_q[i] = ~q_reg[i];
            end
        end
    end

    assign q = q_reg;

endmodule