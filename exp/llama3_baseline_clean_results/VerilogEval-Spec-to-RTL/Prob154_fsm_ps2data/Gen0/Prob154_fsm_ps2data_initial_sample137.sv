module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: idle, 1: byte1, 2: byte2, 3: done
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // byte1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // byte2
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // done
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
                state <= 2'b00;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state != 2'b11) begin
            done <= 1'b0;
        end
    end
end

endmodule