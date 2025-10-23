module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] bit_cnt;
reg [7:0] byte_reg;

parameter IDLE = 2'b00;
parameter RECV_BYTE = 2'b01;
parameter VERIFY_STOP = 2'b10;

reg [1:0] state_reg;
reg [1:0] next_state;

always @(*)
begin
    case(state_reg)
        IDLE: 
            begin
                if (in == 1'b0) 
                    next_state = RECV_BYTE;
                else 
                    next_state = IDLE;
            end
        RECV_BYTE: 
            begin
                if (bit_cnt == 3'd7) 
                    next_state = VERIFY_STOP;
                else 
                    next_state = RECV_BYTE;
            end
        VERIFY_STOP: 
            begin
                if (in == 1'b1) 
                    next_state = IDLE;
                else 
                    next_state = VERIFY_STOP;
            end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk)
begin
    if (reset) 
        begin
            state_reg <= IDLE;
            out_byte_reg <= 8'b0;
            done_reg <= 1'b0;
            bit_cnt <= 3'b0;
            byte_reg <= 8'b0;
        end
    else 
        begin
            state_reg <= next_state;
            case(state_reg)
                RECV_BYTE: 
                    begin
                        byte_reg <= {byte_reg[6:0], in};
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                VERIFY_STOP: 
                    begin
                        out_byte_reg <= byte_reg;
                        done_reg <= 1'b1;
                    end
                IDLE: 
                    begin
                        done_reg <= 1'b0;
                        bit_cnt <= 3'b0;
                        byte_reg <= 8'b0;
                    end
                default: ;
            endcase
        end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule