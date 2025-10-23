module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state;
reg [3:0] next_state;
reg [3:0] shift_count;
reg [3:0] data_reg;

parameter IDLE = 4'b0001;
parameter SHIFT = 4'b0010;
parameter COUNT = 4'b0100;
parameter DONE = 4'b1000;

always @(*) begin
    case(state)
        IDLE: begin
            if (data_reg == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4'b1000) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 4'b0000;
        data_reg <= 4'b0000;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else if (state == IDLE || state == COUNT || state == DONE) begin
            shift_count <= 4'b0000;
        end
        if (state == IDLE || state == SHIFT) begin
            data_reg <= {data_reg[2:0], data};
        end else begin
            data_reg <= 4'b0000;
        end
    end
end

assign shift_ena = (state == SHIFT)? 1'b1 : 1'b0;
assign counting = (state == COUNT)? 1'b1 : 1'b0;
assign done = (state == DONE)? 1'b1 : 1'b0;

endmodule