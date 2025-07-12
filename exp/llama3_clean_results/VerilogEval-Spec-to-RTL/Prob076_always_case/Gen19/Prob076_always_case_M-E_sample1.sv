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

// Decoder outputs
reg [7:0] decoder_out;

// Generate decoder outputs based on select input
always @(*) begin
    case (sel)
        3'b000: decoder_out = 8'b00000001;
        3'b001: decoder_out = 8'b00000010;
        3'b010: decoder_out = 8'b00000100;
        3'b011: decoder_out = 8'b00001000;
        3'b100: decoder_out = 8'b00010000;
        3'b101: decoder_out = 8'b00100000;
        default: decoder_out = 8'b00000000; // Default to 0 if sel is out of range
    endcase
end

// Multiplex data based on decoder outputs
always @(*) begin
    out = 4'b0000; // Initialize out to 0
    if (decoder_out[0]) out = data0; // Select data0 if decoder_out[0] is high
    else if (decoder_out[1]) out = data1; // Select data1 if decoder_out[1] is high
    else if (decoder_out[2]) out = data2; // Select data2 if decoder_out[2] is high
    else if (decoder_out[3]) out = data3; // Select data3 if decoder_out[3] is high
    else if (decoder_out[4]) out = data4; // Select data4 if decoder_out[4] is high
    else if (decoder_out[5]) out = data5; // Select data5 if decoder_out[5] is high
end

endmodule