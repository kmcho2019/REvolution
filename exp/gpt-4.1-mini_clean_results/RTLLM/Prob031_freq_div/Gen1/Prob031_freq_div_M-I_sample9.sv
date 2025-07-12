module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameterized maximum counts for toggling
    localparam CNT_10_MAX = 3'd4;    // counts 0..4 (5 cycles)
    localparam CNT_100_MAX = 6'd49;  // counts 0..49 (50 cycles)

    reg [2:0] cnt_10;     // 3 bits for count up to 4
    reg [5:0] cnt_100;    // 6 bits for count up to 49

    // CLK_50: divide by 2 (toggle every posedge)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Combined always block for CLK_10 and CLK_1 generation to reduce logic area
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10  <= 1'b0;
            cnt_10  <= 3'd0;
            CLK_1   <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_10 logic
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end

            // CLK_1 logic
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end

endmodule