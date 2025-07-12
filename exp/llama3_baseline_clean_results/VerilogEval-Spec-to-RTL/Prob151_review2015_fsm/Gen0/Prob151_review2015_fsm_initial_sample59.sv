module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state; // IDLE, SHIFT, COUNT, DONE
reg [3:0] counter; // counter for shift enable
reg [3:0] pattern; // pattern detector

localparam IDLE = 4'b0000;
localparam SHIFT = 4'b0001;
localparam COUNT = 4'b0010;
localparam DONE_ACK = 4'b0011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        counter <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                counter <= counter + 1;
                if (counter == 4'b0100) begin
                    state <= COUNT;
                    shift_ena <= 1'b0;
                    counter <= 4'b0000;
                end
            end
            COUNT: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE_ACK;
                    counting <= 1'b0;
                end
            end
            DONE_ACK: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule