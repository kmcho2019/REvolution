module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [13:0] cycle_counter; // Enough for 15*1000 = 15000 cycles
    reg [3:0] delay_val;

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            cycle_counter <= 0;
            delay_val <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    
                    // After pattern match, next 4 bits are delay
                    if (shift_reg == 4'b1101) begin
                        delay_val <= {shift_reg[2:0], data};
                        if (cycle_counter == 3) begin
                            state <= COUNTING;
                            cycle_counter <= (delay_val + 1) * 1000 - 1;
                        end else begin
                            cycle_counter <= cycle_counter + 1;
                        end
                    end
                end

                COUNTING: begin
                    if (cycle_counter > 0) begin
                        cycle_counter <= cycle_counter - 1;
                        count <= (cycle_counter - 1) / 1000;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                        cycle_counter <= 0;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule