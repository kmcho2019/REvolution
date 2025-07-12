module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: ERROR
reg [2:0] state_next;
reg [3:0] counter_reg;
reg [3:0] counter_next;
reg [7:0] data_reg;
reg [7:0] data_next;

// State encoding
parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;
parameter ERROR = 3'b100;

// Next state logic
always @(*)
begin
    state_next = state_reg;
    counter_next = counter_reg;
    data_next = data_reg;
    done_reg = 1'b0;

    case(state_reg)
        IDLE:
        begin
            if (~in) // Start bit detected
                state_next = START;
            else if (~reset)
                state_next = IDLE;
        end
        START:
        begin
            state_next = DATA;
            counter_next = 1'b1;
            data_next = {7'b0, in};
        end
        DATA:
        begin
            counter_next = counter_reg + 1'b1;
            data_next = {data_reg[6:0], in};
            if (counter_reg == 4'd7)
                state_next = STOP;
        end
        STOP:
        begin
            if (in) // Stop bit verified
            begin
                out_byte_reg = data_reg;
                done_reg = 1'b1;
                state_next = IDLE;
            end
            else // Stop bit not found, move to ERROR state
                state_next = ERROR;
        end
        ERROR:
        begin
            if (in) // Stop bit or idle line detected
                state_next = IDLE;
        end
        default: state_next = IDLE;
    endcase

    if (~reset)
    begin
        state_next = IDLE;
        counter_next = 4'b0;
        data_next = 8'b0;
    end
end

// Sequential logic
always @(posedge clk)
begin
    state_reg <= state_next;
    counter_reg <= counter_next;
    data_reg <= data_next;
    out_byte <= out_byte_reg;
    done <= done_reg;
end

endmodule