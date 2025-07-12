module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;

reg [7:0] byte1, byte2, byte3;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
        out_bytes_reg <= 24'b0;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                byte3 <= in;
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
                done_reg <= 1;
                out_bytes_reg <= {byte1, byte2, byte3};
            end
            default: state <= IDLE;
        endcase
        if (state != BYTE3) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule