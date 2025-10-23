module TopModule(
    input  [3:0] x,  // x[3], x[2], x[1], x[0]
    output reg f
);
    // Karnaugh map indexing:
    // Rows indexed by Gray code of {x[3], x[0]}: 00,01,11,10
    // Columns indexed by Gray code of {x[1], x[2]}: 00,01,11,10
    //
    // We'll map each input x to its position in the K-map by:
    // 1. Extract row bits: r_bin = {x[3], x[0]}
    // 2. Extract column bits: c_bin = {x[1], x[2]}
    // 3. Convert binary row and column indices to Gray code index
    //    Gray code order for 2-bit values: 0->00,1->01,2->11,3->10
    //
    // To find Gray code index, use function:
    // bin_to_gray(00)=00=0
    // bin_to_gray(01)=01=1
    // bin_to_gray(10)=11=2
    // bin_to_gray(11)=10=3
    //
    // So conversion:
    // gray = bin ^ (bin >> 1)
    //
    // Once row and col indices are computed (0..3), lookup f in the Karnaugh map below.
    //
    // Karnaugh map f values (with d=0 for simplicity):
    //          col=00 col=01 col=11 col=10
    // row=00: d(0)    0     d(0)  d(0)
    // row=01: 0       d(0)  1     0
    // row=11: 1       1     d(0)  d(0)
    // row=10: 1       1     0     d(0)

    // We'll implement this by enumerating all 16 input combinations with the correct mapping.

    function [1:0] bin2gray(input [1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // To get Karnaugh map f from row and col Gray indices:
    function f_lookup;
        input [1:0] row_gray;
        input [1:0] col_gray;
        begin
            // Map (row_gray,col_gray) to value
            case (row_gray)
                2'b00: // row 00
                    case (col_gray)
                        2'b00: f_lookup = 0; // d=0
                        2'b01: f_lookup = 0;
                        2'b11: f_lookup = 0; // d=0
                        2'b10: f_lookup = 0; // d=0
                        default: f_lookup = 0;
                    endcase
                2'b01: // row 01
                    case (col_gray)
                        2'b00: f_lookup = 0;
                        2'b01: f_lookup = 0; // d=0
                        2'b11: f_lookup = 1;
                        2'b10: f_lookup = 0;
                        default: f_lookup = 0;
                    endcase
                2'b11: // row 11
                    case (col_gray)
                        2'b00: f_lookup = 1;
                        2'b01: f_lookup = 1;
                        2'b11: f_lookup = 0; // d=0
                        2'b10: f_lookup = 0; // d=0
                        default: f_lookup = 0;
                    endcase
                2'b10: // row 10
                    case (col_gray)
                        2'b00: f_lookup = 1;
                        2'b01: f_lookup = 1;
                        2'b11: f_lookup = 0;
                        2'b10: f_lookup = 0; // d=0
                        default: f_lookup = 0;
                    endcase
                default: f_lookup = 0;
            endcase
        end
    endfunction

    wire [1:0] row_bin = {x[3], x[0]};
    wire [1:0] col_bin = {x[1], x[2]};
    wire [1:0] row_gray = bin2gray(row_bin);
    wire [1:0] col_gray = bin2gray(col_bin);

    always @(*) begin
        f = f_lookup(row_gray, col_gray);
    end
endmodule