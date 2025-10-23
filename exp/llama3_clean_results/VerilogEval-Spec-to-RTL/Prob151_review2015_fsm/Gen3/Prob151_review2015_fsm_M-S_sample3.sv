module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

reg [2:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 3'b000;
    end else begin
        state <= next_state;
        case (state)
            SHIFT: counter <= counter + 1'b1;
            default: counter <= 3'b000;
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state = (counter == 3'b011)? SHIFT : IDLE;
                if (counter!= 3'b011) counter <= counter + 1'b1;
            end else begin
                next_state = IDLE;
                counter <= 3'b000;
            end
        end
        SHIFT: begin
            if (counter == 3'b100) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE);

endmodule