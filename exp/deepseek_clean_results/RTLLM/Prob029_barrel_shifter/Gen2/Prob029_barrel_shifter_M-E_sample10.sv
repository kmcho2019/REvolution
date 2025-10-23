module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    // Pre-compute all possible rotated versions
    wire [7:0] rotated [0:7];
    
    assign rotated[0] = in;                        // 0 positions
    assign rotated[1] = {in[6:0], in[7]};         // 1 position
    assign rotated[2] = {in[5:0], in[7:6]};       // 2 positions
    assign rotated[3] = {in[4:0], in[7:5]};       // 3 positions
    assign rotated[4] = {in[3:0], in[7:4]};       // 4 positions
    assign rotated[5] = {in[2:0], in[7:3]};       // 5 positions
    assign rotated[6] = {in[1:0], in[7:2]};       // 6 positions
    assign rotated[7] = {in[0], in[7:1]};         // 7 positions

    // Select output based on control signal
    always @(*) begin
        case (ctrl)
            3'b000: out = rotated[0];
            3'b001: out = rotated[1];
            3'b010: out = rotated[2];
            3'b011: out = rotated[3];
            3'b100: out = rotated[4];
            3'b101: out = rotated[5];
            3'b110: out = rotated[6];
            3'b111: out = rotated[7];
            default: out = in;
        endcase
    end
endmodule