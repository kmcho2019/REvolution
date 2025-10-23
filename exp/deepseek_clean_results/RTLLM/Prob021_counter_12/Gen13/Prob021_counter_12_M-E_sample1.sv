module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit Gray code output
);

// Gray code sequence for 0-11
localparam [3:0] GRAY_0  = 4'b0000;
localparam [3:0] GRAY_1  = 4'b0001;
localparam [3:0] GRAY_2  = 4'b0011;
localparam [3:0] GRAY_3  = 4'b0010;
localparam [3:0] GRAY_4  = 4'b0110;
localparam [3:0] GRAY_5  = 4'b0111;
localparam [3:0] GRAY_6  = 4'b0101;
localparam [3:0] GRAY_7  = 4'b0100;
localparam [3:0] GRAY_8  = 4'b1100;
localparam [3:0] GRAY_9  = 4'b1101;
localparam [3:0] GRAY_10 = 4'b1111;
localparam [3:0] GRAY_11 = 4'b1110;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= GRAY_0;
    end else if (valid_count) begin
        case (out)
            GRAY_0:  out <= GRAY_1;
            GRAY_1:  out <= GRAY_2;
            GRAY_2:  out <= GRAY_3;
            GRAY_3:  out <= GRAY_4;
            GRAY_4:  out <= GRAY_5;
            GRAY_5:  out <= GRAY_6;
            GRAY_6:  out <= GRAY_7;
            GRAY_7:  out <= GRAY_8;
            GRAY_8:  out <= GRAY_9;
            GRAY_9:  out <= GRAY_10;
            GRAY_10: out <= GRAY_11;
            GRAY_11: out <= GRAY_0;
            default: out <= GRAY_0;
        endcase
    end
end

endmodule