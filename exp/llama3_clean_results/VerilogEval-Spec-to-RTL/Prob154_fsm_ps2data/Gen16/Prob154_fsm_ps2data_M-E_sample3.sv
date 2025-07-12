module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [23:0] byte_accumulator;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        byte_accumulator <= 24'b0;
        state <= 2'b00;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    byte_accumulator <= {in, 16'b0};
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
                done <= 1'b0;
            end
            2'b01: begin
                byte_accumulator <= {byte_accumulator[15:0], in};
                state <= 2'b10;
                done <= 1'b0;
            end
            2'b10: begin
                byte_accumulator <= {byte_accumulator[7:0], in, 8'b0};
                state <= 2'b00;
                done <= 1'b1;
            end
            default: begin
                state <= 2'b00;
                done <= 1'b0;
            end
        endcase
    end
    out_bytes <= byte_accumulator;
end

endmodule