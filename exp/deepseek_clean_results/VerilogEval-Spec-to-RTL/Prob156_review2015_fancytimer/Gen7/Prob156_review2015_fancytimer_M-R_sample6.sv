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
    localparam IDLE        = 3'b000;
    localparam DETECTING   = 3'b001;
    localparam CAPTURE     = 3'b010;
    localparam COUNTING    = 3'b011;
    localparam DONE       = 3'b100;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay_value;
    reg [3:0] count_down;
    reg [9:0] period_counter; // Counts 0-999 (1000 cycles)
    reg [2:0] bit_counter;

    // Pattern detection and delay capture
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            bit_counter <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= DETECTING;
                        bit_counter <= 1;
                    end
                end
                
                DETECTING: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        state <= CAPTURE;
                        delay_value <= shift_reg;
                    end
                end
                
                CAPTURE: begin
                    count_down <= delay_value;
                    period_counter <= 0;
                    state <= COUNTING;
                end
                
                COUNTING: begin
                    if (period_counter == 999) begin
                        period_counter <= 0;
                        count_down <= count_down - 1;
                        if (count_down == 0)
                            state <= DONE;
                    end else begin
                        period_counter <= period_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? count_down : 4'b0;

endmodule