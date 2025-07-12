module GameCell(
    input   logic        cell,
    input   logic        n1, n2, n3, n4, n5, n6, n7, n8,
    output  logic        next_cell
);

    logic [2:0] neighbors;

    assign neighbors = {n8, n7, n6, n5, n4, n3, n2, n1};

    always_comb begin
        case(neighbors)
            9'b0???????0, 9'b0???????1: next_cell = 1'b0; // 0-1 neighbors
            9'b???????10, 9'b???????11: next_cell = cell; // 2 neighbors
            9'b??????100, 9'b??????101, 
            9'b??????110, 9'b??????111, 
            9'b?????1000, 9'b?????1001, 
            9'b?????1010, 9'b?????1011, 
            9'b?????1100, 9'b?????1101, 
            9'b?????1110, 9'b?????1111: next_cell = 1'b1; // 3 neighbors
            default: next_cell = 1'b0; // 4+ neighbors
        endcase
    end

endmodule

module TopModule(
    input   logic        clk,
    input   logic        load,
    input   logic [255:0] data,
    output  logic [255:0] q
);

    logic [255:0] next_q;

    assign q = next_q;

    for(genvar i = 0; i < 256; i++) begin: gen_cells
        logic cell, n1, n2, n3, n4, n5, n6, n7, n8, next_cell;

        assign cell = (load)? data[i] : next_q[i];

        assign n1 = (load)? data[(i + 1) % 256] : next_q[(i + 1) % 256];
        assign n2 = (load)? data[((i + 16) % 256)] : next_q[((i + 16) % 256)];
        assign n3 = (load)? data[((i + 17) % 256)] : next_q[((i + 17) % 256)];
        assign n4 = (load)? data[((i - 1 + 256) % 256)] : next_q[((i - 1 + 256) % 256)];
        assign n5 = (load)? data[((i - 16 + 256) % 256)] : next_q[((i - 16 + 256) % 256)];
        assign n6 = (load)? data[((i - 17 + 256) % 256)] : next_q[((i - 17 + 256) % 256)];
        assign n7 = (load)? data[((i + 15) % 16 + ((i / 16) * 16) % 256)] : next_q[((i + 15) % 16 + ((i / 16) * 16) % 256)];
        assign n8 = (load)? data[((i - 15 + 256) % 16 + ((i / 16) * 16) % 256)] : next_q[((i - 15 + 256) % 16 + ((i / 16) * 16) % 256)];

        GameCell cell_module(
           .cell(cell),
           .n1(n1),.n2(n2),.n3(n3),.n4(n4),.n5(n5),.n6(n6),.n7(n7),.n8(n8),
           .next_cell(next_cell)
        );

        always_ff @(posedge clk) begin
            next_q[i] <= next_cell;
        end
    end

endmodule