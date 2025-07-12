module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [31:0] yout_r;
reg [3:0] seg1, seg2, seg3, seg4;
reg [3:0] prod1, prod2, prod3, prod4;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        yout_r <= 0;
        done <= 0;
        seg1 <= 0;
        seg2 <= 0;
        seg3 <= 0;
        seg4 <= 0;
        prod1 <= 0;
        prod2 <= 0;
        prod3 <= 0;
        prod4 <= 0;
    end else begin
        case (state)
            0: begin
                if (start) begin
                    seg1 <= ain[3:0];
                    seg2 <= ain[7:4];
                    seg3 <= ain[11:8];
                    seg4 <= ain[15:12];
                    state <= 1;
                end
            end
            1: begin
                prod1 <= seg1 * bin[3:0];
                prod2 <= seg2 * bin[3:0];
                prod3 <= seg3 * bin[3:0];
                prod4 <= seg4 * bin[3:0];
                state <= 2;
            end
            2: begin
                yout_r <= (prod1 << 0) + (prod2 << 4) + (prod3 << 8) + (prod4 << 12);
                done <= 1;
                state <= 3;
            end
            3: begin
                done <= 0;
                state <= 0;
            end
        endcase
    end
end

assign yout = yout_r;

endmodule