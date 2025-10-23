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
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [15:0] cycle_counter; // Enough for (15+1)*1000 = 16000 cycles
    reg [3:0] delay_value;
    reg [2:0] bit_counter;

    // Shift register and bit counter
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            bit_counter <= 0;
        end else if (state == IDLE) begin
            shift_reg <= {shift_reg[2:0], data};
            bit_counter <= (shift_reg[2:0] == 3'b110 && data) ? 3'b1 : 
                          (bit_counter != 0) ? bit_counter + 1 : 0;
        end
    end

    // Main counter and delay capture
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 0;
            delay_value <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (bit_counter == 4) begin
                        delay_value <= shift_reg;
                        cycle_counter <= (shift_reg + 1) * 1000;
                        state <= COUNTING;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 0) begin
                        state <= DONE;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
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