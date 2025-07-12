module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg;
reg [7:0] byte1_reg;
reg [7:0] byte2_reg;

parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        done_reg <= 0;
        out_bytes_reg <= 0;
        byte1_reg <= 0;
        byte2_reg <= 0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (in[3]) begin
                    state_reg <= BYTE1;
                    byte1_reg <= in;
                end
            end
            BYTE1: begin
                state_reg <= BYTE2;
                byte2_reg <= in;
            end
            BYTE2: begin
                state_reg <= IDLE;
                out_bytes_reg <= {byte1_reg, byte2_reg, in};
                done_reg <= 1;
            end
            default: state_reg <= IDLE;
        endcase
        if (state_reg!= BYTE2) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule