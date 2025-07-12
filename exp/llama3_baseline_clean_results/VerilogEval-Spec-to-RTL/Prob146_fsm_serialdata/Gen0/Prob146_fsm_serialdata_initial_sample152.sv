module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_reg;
reg [2:0] state_reg;
reg [2:0] next_state;
reg done_reg;

localparam IDLE = 3'b001;
localparam START_BIT_RECEIVED = 3'b010;
localparam DATA_BITS_COLLECTED = 3'b011;
localparam STOP_BIT_ERROR = 3'b100;

always @(*) begin
    case(state_reg)
        IDLE: begin
            if(in == 0) begin
                next_state = START_BIT_RECEIVED;
            end else begin
                next_state = IDLE;
            end
        end
        START_BIT_RECEIVED: begin
            if(data_reg == 8'b11111111) begin
                if(in == 1) begin
                    next_state = DATA_BITS_COLLECTED;
                end else begin
                    next_state = START_BIT_RECEIVED;
                end
            end else begin
                next_state = START_BIT_RECEIVED;
            end
        end
        DATA_BITS_COLLECTED: begin
            if(in == 1) begin
                next_state = IDLE;
            end else begin
                next_state = STOP_BIT_ERROR;
            end
        end
        STOP_BIT_ERROR: begin
            if(in == 1) begin
                next_state = IDLE;
            end else begin
                next_state = STOP_BIT_ERROR;
            end
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state_reg <= IDLE;
        data_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        state_reg <= next_state;
        if(state_reg == START_BIT_RECEIVED) begin
            data_reg <= {data_reg[6:0], in};
        end
        if(next_state == DATA_BITS_COLLECTED && in == 1) begin
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
        if(next_state == IDLE) begin
            data_reg <= 8'b0;
        end
    end
end

assign out_byte = data_reg;
assign done = done_reg;

endmodule