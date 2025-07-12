module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    reg [1:0] out_onehot; // 2-bit one-hot: 01 = ringer on, 10 = motor on, 00 = both off

    always @(*) begin
        if (ring) begin
            if (vibrate_mode) begin
                out_onehot = 2'b10; // motor on
            end else begin
                out_onehot = 2'b01; // ringer on
            end
        end else begin
            out_onehot = 2'b00; // both off
        end
    end

    assign ringer = out_onehot[0];
    assign motor  = out_onehot[1];

endmodule