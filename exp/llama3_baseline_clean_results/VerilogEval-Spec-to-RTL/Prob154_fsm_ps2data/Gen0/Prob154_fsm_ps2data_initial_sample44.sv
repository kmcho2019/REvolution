module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end
    else begin
        case(state)
            IDLE: begin
                if(in[3] == 1'b1) begin
                    out_bytes_reg[7:0] <= in;
                    state <= BYTE1;
                end
                else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                out_bytes_reg[15:8] <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                out_bytes_reg[23:16] <= in;
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
                done_reg <= 1'b1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if(reset) begin
        out_bytes <= 24'd0;
        done <= 1'b0;
    end
    else begin
        out_bytes <= out_bytes_reg;
        done <= (state == BYTE3) ? 1'b1 : 1'b0;
    end
end

endmodule