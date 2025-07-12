module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_reg;
reg [2:0] state_reg, state_next;
reg [2:0] cnt_reg, cnt_next;
reg done_reg, done_next;

// Define the states
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        cnt_reg <= 0;
        data_reg <= 0;
        done_reg <= 0;
    end else begin
        state_reg <= state_next;
        cnt_reg <= cnt_next;
        data_reg <= data_reg;
        done_reg <= done_next;
    end
end

always @(*) begin
    state_next = state_reg;
    cnt_next = cnt_reg;
    done_next = 0;
    
    case (state_reg)
        IDLE: begin
            if (~in) begin
                state_next = START;
            end
        end
        START: begin
            state_next = DATA;
            cnt_next = 1;
            data_reg = {7'b0, in};
        end
        DATA: begin
            data_reg = {data_reg[6:0], in};
            cnt_next = cnt_reg + 1;
            if (cnt_reg == 7) begin
                state_next = STOP;
            end
        end
        STOP: begin
            if (in) begin
                state_next = IDLE;
                done_next = 1;
            end else begin
                state_next = STOP;
            end
        end
        default: state_next = IDLE;
    endcase
end

assign out_byte = data_reg;
assign done = done_reg;

endmodule