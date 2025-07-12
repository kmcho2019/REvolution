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

wire [3:0] lower_mux_out;
wire [3:0] upper_mux_out;
wire [3:0] final_mux_out;
wire valid_sel;

// Lower group mux (data0-2)
assign lower_mux_out = (sel[1:0] == 2'b00) ? data0 :
                      (sel[1:0] == 2'b01) ? data1 :
                      (sel[1:0] == 2'b10) ? data2 : 4'b0;

// Upper group mux (data3-5)
assign upper_mux_out = (sel[1:0] == 2'b00) ? data3 :
                      (sel[1:0] == 2'b01) ? data4 :
                      (sel[1:0] == 2'b10) ? data5 : 4'b0;

// Final selection between groups
assign final_mux_out = sel[2] ? upper_mux_out : lower_mux_out;

// Valid selection check (sel <= 5)
assign valid_sel = (sel <= 3'b101);

// Output gating for invalid selections
assign out = valid_sel ? final_mux_out : 4'b0;

endmodule