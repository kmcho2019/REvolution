module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] state_reg;
reg [1:0] next_state;
reg done_reg;

// state definition
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(*) begin
    case(state_reg)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
                out_bytes_reg = {in, 16'b0};
            end else begin
                next_state = IDLE;
                out_bytes_reg = out_bytes_reg;
            end
            done_reg = 1'b0;
        end
        BYTE1: begin
            next_state = BYTE2;
            out_bytes_reg = {out_bytes_reg[23:8], in};
            done_reg = 1'b0;
        end
        BYTE2: begin
            next_state = BYTE3;
            out_bytes_reg = {out_bytes_reg[23:8], out_bytes_reg[7:0], in};
            done_reg = 1'b0;
        end
        BYTE3: begin
            next_state = IDLE;
            out_bytes_reg = out_bytes_reg;
            done_reg = 1'b1;
        end
        default: begin
            next_state = IDLE;
            out_bytes_reg = out_bytes_reg;
            done_reg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state_reg <= IDLE;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        state_reg <= next_state;
        out_bytes_reg <= out_bytes_reg;
        done_reg <= done_reg;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule