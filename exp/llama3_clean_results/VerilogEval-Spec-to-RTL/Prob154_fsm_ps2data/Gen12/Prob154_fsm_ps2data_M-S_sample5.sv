module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule