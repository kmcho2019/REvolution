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
    reg [13:0] counter;  // Handles up to (15+1)*1000 = 16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            counter <= 0;
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
                        state <= COUNTING;
                        counter <= 0;  // Start counting delay bits
                    end
                end

                COUNTING: begin
                    if (counter < 4) begin  // First 4 cycles after 1101 capture delay
                        shift_reg <= {shift_reg[2:0], data};
                        counter <= counter + 1;
                        
                        if (counter == 3) begin  // All 4 delay bits received
                            counter <= ({shift_reg[2:0], data} + 1) * 1000;
                            counting <= 1;
                            count <= {shift_reg[2:0], data};
                        end
                    end else begin  // Counting down
                        counter <= counter - 1;
                        if (counter == 1001) begin  // Update count every 1000 cycles
                            count <= count - 1;
                        end
                        
                        if (counter == 1) begin  // Counting complete
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end

                DONE: begin
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