module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  [23:0]  out_bytes,
    output          done
);

reg [23:0]  out_bytes_reg;
reg         done_reg;
reg [1:0]   state_reg;
reg [1:0]   state_next;
reg [7:0]   byte1_reg;
reg [7:0]   byte2_reg;

parameter IDLE = 2'b00;
parameter CAPTURE_BYTE_1 = 2'b01;
parameter CAPTURE_BYTE_2 = 2'b10;
parameter CAPTURE_BYTE_3 = 2'b11;

always @(*) begin
    case(state_reg)
        IDLE: begin
            if (in[3] == 1'b1) begin
                state_next = CAPTURE_BYTE_1;
            end else begin
                state_next = IDLE;
            end
        end
        CAPTURE_BYTE_1: begin
            state_next = CAPTURE_BYTE_2;
        end
        CAPTURE_BYTE_2: begin
            state_next = CAPTURE_BYTE_3;
        end
        CAPTURE_BYTE_3: begin
            state_next = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        done_reg <= 0;
        out_bytes_reg <= 0;
        byte1_reg <= 0;
        byte2_reg <= 0;
    end else begin
        state_reg <= state_next;
        case(state_reg)
            CAPTURE_BYTE_1: begin
                byte1_reg <= in;
            end
            CAPTURE_BYTE_2: begin
                byte2_reg <= in;
            end
            CAPTURE_BYTE_3: begin
                out_bytes_reg <= {byte1_reg, byte2_reg, in};
                done_reg <= 1'b1;
            end
            IDLE: begin
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state_reg == CAPTURE_BYTE_3);

endmodule