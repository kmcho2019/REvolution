module TopModule (
    input  [31:0] in,
    output [31:0] out
);

// Extract bytes from input
wire [7:0] byte0 = in[7:0];
wire [7:0] byte1 = in[15:8];
wire [7:0] byte2 = in[23:16];
wire [7:0] byte3 = in[31:24];

// Selector indices for reversed bytes: 
// out byte0 = in byte3 (index 3), out byte1 = in byte2 (2), etc.
localparam [1:0] SEL_BYTE0 = 2'd3;
localparam [1:0] SEL_BYTE1 = 2'd2;
localparam [1:0] SEL_BYTE2 = 2'd1;
localparam [1:0] SEL_BYTE3 = 2'd0;

// 4-to-1 mux for each output byte selecting among input bytes
function [7:0] byte_mux;
    input [1:0] sel;
    input [7:0] b0, b1, b2, b3;
    begin
        case(sel)
            2'd0: byte_mux = b0;
            2'd1: byte_mux = b1;
            2'd2: byte_mux = b2;
            2'd3: byte_mux = b3;
            default: byte_mux = 8'h00;
        endcase
    end
endfunction

wire [7:0] out_byte0 = byte_mux(SEL_BYTE0, byte0, byte1, byte2, byte3);
wire [7:0] out_byte1 = byte_mux(SEL_BYTE1, byte0, byte1, byte2, byte3);
wire [7:0] out_byte2 = byte_mux(SEL_BYTE2, byte0, byte1, byte2, byte3);
wire [7:0] out_byte3 = byte_mux(SEL_BYTE3, byte0, byte1, byte2, byte3);

// Concatenate the mux outputs as reversed bytes
assign out = {out_byte0, out_byte1, out_byte2, out_byte3};

endmodule