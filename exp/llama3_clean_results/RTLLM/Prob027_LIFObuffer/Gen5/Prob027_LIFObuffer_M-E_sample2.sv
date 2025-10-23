module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] buffer [0:3];
reg [1:0] RP;
reg [1:0] WP;
reg [1:0] next_WP;

always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            buffer[i] <= 4'd0;
        end
        RP <= 2'd0;
        WP <= 2'd0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (!RW &&!FULL) begin // Push operation
            buffer[WP] <= dataIn;
            WP <= (WP + 1) % 4;
        end else if (RW &&!EMPTY) begin // Pop operation
            dataOut <= buffer[RP];
            RP <= (RP + 1) % 4;
        end
        EMPTY <= (RP == WP);
        FULL <= ((WP + 1) % 4 == RP);
    end
end

endmodule