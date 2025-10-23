module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    // Apply shifts sequentially based on control signal
    wire [7:0] shifted_by_4;
    assign shifted_by_4 = {in[3:0], in[7:4]};
    
    wire [7:0] shifted_by_2;
    assign shifted_by_2 = (ctrl[2]) ? shifted_by_4 : in;
    assign shifted_by_2 = (ctrl[1]) ? {shifted_by_2[5:0], shifted_by_2[7:6]} : shifted_by_2;
    
    assign out = (ctrl[0]) ? {shifted_by_2[6:0], shifted_by_2[7]} : shifted_by_2;

endmodule