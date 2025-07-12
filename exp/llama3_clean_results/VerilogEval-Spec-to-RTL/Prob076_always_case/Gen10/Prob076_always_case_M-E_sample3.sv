module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

always @(*) begin
    reg [3:0] temp_out;
    
    // Create masks for each data input based on the sel signal
    reg [3:0] mask0, mask1, mask2, mask3, mask4, mask5;
    
    // Use bitwise operations to select the desired data input
    mask0 = (sel == 3'b000)? 4'b1111 : 4'b0000;
    mask1 = (sel == 3'b001)? 4'b1111 : 4'b0000;
    mask2 = (sel == 3'b010)? 4'b1111 : 4'b0000;
    mask3 = (sel == 3'b011)? 4'b1111 : 4'b0000;
    mask4 = (sel == 3'b100)? 4'b1111 : 4'b0000;
    mask5 = (sel == 3'b101)? 4'b1111 : 4'b0000;
    
    // Use bitwise AND to enable the selected data input
    temp_out = (data0 & mask0) | (data1 & mask1) | (data2 & mask2) | (data3 & mask3) | (data4 & mask4) | (data5 & mask5);
    
    out = temp_out;
end

endmodule