module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State parameters
    localparam IDLE     = 2'b00;
    localparam GET_DELAY = 2'b01;
    localparam COUNT    = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [9:0] cycle_counter;
    reg [3:0] delay_counter;
    reg [1:0] bit_counter;

    // Continuous assignments for outputs
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? delay_counter : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            cycle_counter <= 0;
            delay_counter <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= GET_DELAY;
                        bit_counter <= 0;
                    end
                end

                GET_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        delay_reg <= shift_reg;
                        delay_counter <= shift_reg;
                        cycle_counter <= 0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            state <= DONE;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
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

endmodule