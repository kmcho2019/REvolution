module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [15:0] cycle_counter; // Holds (delay+1)*1000 cycles
    reg [3:0] delay_value;
    reg [2:0] bit_counter;
    reg [9:0] sub_counter;    // Counts 0-999 for each period

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            bit_counter <= 0;
            cycle_counter <= 0;
            delay_value <= 0;
            sub_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= CAPTURE;
                        bit_counter <= 1;
                    end
                end
                
                CAPTURE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        delay_value <= {shift_reg[2:0], data};
                        cycle_counter <= ({shift_reg[2:0], data} + 1) * 1000;
                        state <= COUNTING;
                    end
                end
                
                COUNTING: begin
                    if (sub_counter == 999) begin
                        sub_counter <= 0;
                        cycle_counter <= cycle_counter - 1000;
                        if (cycle_counter == 1000) state <= DONE;
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) state <= IDLE;
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        counting = (state == COUNTING);
        done = (state == DONE);
        count = (state == COUNTING) ? (cycle_counter / 1000) : 4'b0;
    end

endmodule