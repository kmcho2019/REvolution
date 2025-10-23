module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam IDLE    = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;
    
    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [13:0] counter;
    reg [13:0] target_cycles;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        counter <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end
                
                CAPTURE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counter <= counter + 1;
                    
                    if (counter == 3) begin
                        state <= COUNT;
                        target_cycles <= (shift_reg + 1) * 1000;
                        counter <= 0;
                        counting <= 1;
                    end
                end
                
                COUNT: begin
                    counter <= counter + 1;
                    count <= target_cycles/1000 - counter/1000 - 1;
                    
                    if (counter == target_cycles - 1) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule