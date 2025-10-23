module TopModule(
    input [3:0] x,
    output f
);

    // Define the outputs for each combination of x[0] and x[1]
    wire row00, row01, row11, row10;

    // For x[2]x[3] = 00
    assign row00 = 1'b1; // When x[0]x[1] = 00 or x[0]x[1] = 10
    assign row01 = 1'b0;
    assign row11 = 1'b0;
    assign row10 = 1'b1;

    // For x[2]x[3] = 01
    wire row01_01, row01_11, row01_10, row01_00;
    assign row01_01 = 1'b0;
    assign row01_11 = 1'b0;
    assign row01_10 = 1'b0;
    assign row01_00 = 1'b0;

    // For x[2]x[3] = 11
    wire row11_01, row11_11, row11_10, row11_00;
    assign row11_01 = 1'b1;
    assign row11_11 = 1'b1;
    assign row11_10 = 1'b0;
    assign row11_00 = 1'b1;

    // For x[2]x[3] = 10
    wire row10_01, row10_11, row10_10, row10_00;
    assign row10_01 = 1'b1;
    assign row10_11 = 1'b0;
    assign row10_10 = 1'b1;
    assign row10_00 = 1'b1;

    // Top-level MUX selection based on x[2] and x[3]
    wire [1:0] select;
    assign select = {x[2], x[3]};

    // Sub-MUX selection based on x[0] and x[1]
    wire [1:0] sub_select;
    assign sub_select = {x[1], x[0]};

    // Hierarchical MUX structure
    wire [3:0] row_out;
    always @(*) begin
        case (select)
            2'b00: row_out = {row00, row01, row11, row10};
            2'b01: row_out = {row01_00, row01_01, row01_11, row01_10};
            2'b11: row_out = {row11_00, row11_01, row11_11, row11_10};
            2'b10: row_out = {row10_00, row10_01, row10_11, row10_10};
            default: row_out = 4'b0;
        endcase
    end

    assign f = row_out[2 * sub_select + sub_select];

endmodule