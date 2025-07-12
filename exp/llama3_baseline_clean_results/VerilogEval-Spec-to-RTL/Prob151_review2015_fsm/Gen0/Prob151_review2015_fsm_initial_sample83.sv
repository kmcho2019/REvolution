module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] data_shift;
reg [3:0] state;
parameter IDLE = 4'b0000, 
           SHIFT = 4'b0001, 
           COUNT = 4'b0010, 
           NOTIFY = 4'b0011;

always @(posedge clk or posedge reset) 
begin
    if(reset) 
    begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        data_shift <= 0;
    end
    else 
    begin
        case(state)
            IDLE: 
            begin
                if(data_shift == 4'b1101) 
                begin
                    state <= SHIFT;
                    data_shift <= 0;
                end
                else 
                begin
                    data_shift <= {data_shift[2:0], data};
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: 
            begin
                if(data_shift == 4'b1111) 
                begin
                    state <= COUNT;
                    data_shift <= 0;
                end
                else 
                begin
                    data_shift <= data_shift + 1;
                end
                shift_ena <= 1;
                counting <= 0;
                done <= 0;
            end
            COUNT: 
            begin
                if(done_counting) 
                begin
                    state <= NOTIFY;
                end
                counting <= 1;
                done <= 0;
                shift_ena <= 0;
            end
            NOTIFY: 
            begin
                if(ack) 
                begin
                    state <= IDLE;
                end
                counting <= 0;
                done <= 1;
                shift_ena <= 0;
            end
            default: 
            begin
                state <= IDLE;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
                data_shift <= 0;
            end
        endcase
    end
end

endmodule