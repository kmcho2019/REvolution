module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

parameter SEQUENCE_BITS = 4;
parameter DELAY_BITS = 4;
parameter COUNTER_BITS = 20;

reg [SEQUENCE_BITS-1:0] seq_reg;
reg [DELAY_BITS-1:0] delay_reg;
reg [COUNTER_BITS-1:0] counter;
reg [1:0] state;
reg [COUNTER_BITS-1:0] counter_init;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay_reg <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
                if (delay_reg[DELAY_BITS-1]) begin
                    state <= 2;
                    counter_init <= (delay_reg + 1) * 1000;
                    counter <= counter_init;
                end
            end
            2: begin // COUNT
                counting <= 1;
                counter <= counter - 1;
                if (counter == 0) begin
                    state <= 3;
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack == 1'b1) begin
                    state <= 0;
                    counting <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = (counter >= 1000)? delay_reg : (counter >= 2000)? delay_reg - 1 : 
               (counter >= 3000)? delay_reg - 2 : (counter >= 4000)? delay_reg - 3 : 0;

endmodule