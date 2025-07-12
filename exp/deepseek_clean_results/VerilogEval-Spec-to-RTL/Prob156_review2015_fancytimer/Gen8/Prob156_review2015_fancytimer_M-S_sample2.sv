module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE      = 0;
    localparam CAPTURE   = 1;
    localparam COUNTING  = 2;
    localparam DONE      = 3;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [15:0] counter; // Enough for max 16*1000=16000 cycles
    reg [3:0] remaining;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            counter <= 0;
            delay <= 0;
            remaining <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        counter <= 0;
                    end
                end
                
                CAPTURE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counter <= counter + 1;
                    if (counter == 3) begin
                        delay <= shift_reg;
                        remaining <= shift_reg;
                        counter <= 0;
                        state <= COUNTING;
                    end
                end
                
                COUNTING: begin
                    counter <= counter + 1;
                    if (counter == 999) begin
                        counter <= 0;
                        remaining <= remaining - 1;
                        if (remaining == 0) begin
                            state <= DONE;
                        end
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 0;
                    end
                end
            endcase
        end
    end

    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? remaining : 4'b0;

endmodule