module ROM #(
    parameter [15:0] SEG0_VAL = 16'hA0A0,
    parameter [15:0] SEG1_VAL = 16'hB1B1,
    parameter [15:0] SEG2_VAL = 16'hC2C2,
    parameter [15:0] SEG3_VAL = 16'hD3D3
)(
    input [7:0] addr,
    output reg [15:0] dout
);

    // Segment selection based on upper address bits
    wire [1:0] seg_sel = addr[7:6];
    
    // Segment-specific data
    wire [15:0] seg0_out = (addr[5:0] == 6'd0) ? SEG0_VAL : 16'h0000;
    wire [15:0] seg1_out = (addr[5:0] == 6'd1) ? SEG1_VAL : 16'h0000;
    wire [15:0] seg2_out = (addr[5:0] == 6'd2) ? SEG2_VAL : 16'h0000;
    wire [15:0] seg3_out = (addr[5:0] == 6'd3) ? SEG3_VAL : 16'h0000;
    
    // Output multiplexing
    always @(*) begin
        case (seg_sel)
            2'b00: dout = seg0_out;
            2'b01: dout = seg1_out;
            2'b10: dout = seg2_out;
            2'b11: dout = seg3_out;
            default: dout = 16'h0000;
        endcase
    end

endmodule