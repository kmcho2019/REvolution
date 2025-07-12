module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

// CAM-style matching
wire match0 = (sel == 3'b000);
wire match1 = (sel == 3'b001);
wire match2 = (sel == 3'b010);
wire match3 = (sel == 3'b011);
wire match4 = (sel == 3'b100);
wire match5 = (sel == 3'b101);

// Priority encoder for valid matches
wire valid_match = |{match5, match4, match3, match2, match1, match0};

// Output selection
assign out = ({4{match0}} & data0) |
             ({4{match1}} & data1) |
             ({4{match2}} & data2) |
             ({4{match3}} & data3) |
             ({4{match4}} & data4) |
             ({4{match5}} & data5) |
             ({4{~valid_match}} & 4'b0000);

endmodule