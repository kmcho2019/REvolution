module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output reg [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] shift4 = {in[3:0], 4'b0000};
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] shift2 = {in[5:0], 2'b00};
    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] shift1 = {in[6:0], 1'b0};

    always @(*) begin
        if (ctrl[2]) begin
            if (ctrl[1]) begin
                if (ctrl[0]) begin
                    out = {shift1[3:0], shift1[7:4], 4'b0000};
                end else begin
                    out = {shift2[5:0], shift2[7:6], 2'b00};
                end
            end else if (ctrl[0]) begin
                out = {shift4[6:0], shift4[7], 1'b0};
            end else begin
                out = shift4;
            end
        end else if (ctrl[1]) begin
            if (ctrl[0]) begin
                out = {shift2[6:0], shift2[7], 1'b0};
            end else begin
                out = shift2;
            end
        end else if (ctrl[0]) begin
            out = shift1;
        end else begin
            out = in;
        end
    end
endmodule