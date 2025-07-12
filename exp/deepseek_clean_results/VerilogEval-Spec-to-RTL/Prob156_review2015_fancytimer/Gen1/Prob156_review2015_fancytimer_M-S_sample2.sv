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
    reg [7:0] shift_reg;    // Combines pattern (bits 7:4) and delay (bits 3:0)
    reg [9:0] main_counter; // Counts bits (0-7) and cycles (0-999)
    reg [3:0] delay_value;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            main_counter <= 10'b0;
            delay_value <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[6:0], data};
                    if (shift_reg[7:4] == 4'b1101 && main_counter == 7) begin
                        delay_value <= shift_reg[3:0];
                        state <= COUNTING;
                        main_counter <= 10'b0;
                    end
                    main_counter <= (main_counter == 7) ? 0 : main_counter + 1;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    if (main_counter == 999) begin
                        if (delay_value == 0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            delay_value <= delay_value - 1;
                        end
                        main_counter <= 0;
                    end else begin
                        main_counter <= main_counter + 1;
                    end
                    count <= delay_value;
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        main_counter <= 0;
                    end
                end
            endcase
        end
    end

endmodule