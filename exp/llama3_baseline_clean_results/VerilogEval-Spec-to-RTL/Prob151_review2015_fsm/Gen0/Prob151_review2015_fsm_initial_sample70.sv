module TopModule(
    input         clk,
    input         reset,
    input         data,
    input         done_counting,
    input         ack,
    output        shift_ena,
    output        counting,
    output        done
);

reg [3:0]        pattern_register;
reg [2:0]        shift_counter;
reg [1:0]        state;

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE_WAIT = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_register <= 4'b0000;
        shift_counter <= 3'b000;
        counting <= 1'b0;
        done <= 1'b0;
        shift_ena <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern_register <= {data, pattern_register[3:1]};
                if (pattern_register == 4'b1101) begin
                    state <= SHIFT;
                    shift_counter <= 3'b000;
                    shift_ena <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                if (shift_counter == 3'b111) begin
                    state <= COUNT;
                    counting <= 1'b1;
                    shift_ena <= 1'b0;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                    state <= SHIFT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE_WAIT;
                    counting <= 1'b0;
                    done <= 1'b1;
                end else begin
                    state <= COUNT;
                end
            end
            DONE_WAIT: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end else begin
                    state <= DONE_WAIT;
                end
            end
        endcase
    end
end

endmodule