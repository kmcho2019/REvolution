module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
    end else begin
        case (state)
            0: begin
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin
                byte2 <= in;
                state <= 2;
            end
            2: begin
                byte3 <= in;
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2) begin
        out_bytes <= {byte1, byte2, byte3};
        done <= 1;
    end else begin
        done <= 0;
    end
end

endmodule