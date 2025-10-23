module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    wire [63:0] block_selected;
    wire [3:0]  sel_low  = sel[3:0];
    wire [3:0]  sel_high = sel[7:4];

    // First-level mux: select one 64-bit block out of 16 blocks
    // Each block is 64 bits = 16 4-bit chunks
    // Using a combinational always block with case statement for clarity
    reg [63:0] block_mux;
    always @(*) begin
        case (sel_high)
            4'd0:  block_mux = in[ 63:  0];
            4'd1:  block_mux = in[127: 64];
            4'd2:  block_mux = in[191:128];
            4'd3:  block_mux = in[255:192];
            4'd4:  block_mux = in[319:256];
            4'd5:  block_mux = in[383:320];
            4'd6:  block_mux = in[447:384];
            4'd7:  block_mux = in[511:448];
            4'd8:  block_mux = in[575:512];
            4'd9:  block_mux = in[639:576];
            4'd10: block_mux = in[703:640];
            4'd11: block_mux = in[767:704];
            4'd12: block_mux = in[831:768];
            4'd13: block_mux = in[895:832];
            4'd14: block_mux = in[959:896];
            4'd15: block_mux = in[1023:960];
            default: block_mux = 64'd0;
        endcase
    end

    // Second-level mux: select one 4-bit chunk out of 16 from the selected block
    assign out = block_mux[sel_low*4 +: 4];

endmodule