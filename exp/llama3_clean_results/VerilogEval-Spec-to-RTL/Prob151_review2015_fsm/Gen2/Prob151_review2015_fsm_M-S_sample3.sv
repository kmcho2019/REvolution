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

reg [1:0] state;
reg [3:0] pattern;
reg [1:0] counter;

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNTING_DONE = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        counter <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    counter <= 2'b00;
                    shift_ena <= 1'b1;
                end else begin
                    shift_ena <= 1'b0;
                end
            end
            SHIFT: begin
                counter <= counter + 1'b1;
                if (counter == 2'b11) begin
                    state <= COUNTING_DONE;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                end else begin
                    shift_ena <= 1'b1;
                end
            end
            COUNTING_DONE: begin
                if (done_counting) begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule