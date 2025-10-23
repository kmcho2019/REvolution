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
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam WAIT  = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] interval_counter; // Counts delay downto 0

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            delay <= 0;
            cycle_counter <= 0;
            interval_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    shift_reg <= {shift_reg[2:0], data};
                    
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_reg <= 0;  // Clear for delay bits
                    end
                end

                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    
                    if (shift_reg == 3) begin  // After 4 bits received
                        delay <= {shift_reg[2:0], data};
                        interval_counter <= {shift_reg[2:0], data};
                        count <= {shift_reg[2:0], data};
                        state <= COUNT;
                        cycle_counter <= 0;
                        counting <= 1;
                    end
                end

                COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (interval_counter == 0) begin
                            state <= WAIT;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            interval_counter <= interval_counter - 1;
                            count <= interval_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                WAIT: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        shift_reg <= 0;
                    end
                end
            endcase
        end
    end

endmodule