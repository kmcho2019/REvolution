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
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [15:0] counter;
    reg [3:0] delay;

    // Continuous outputs
    assign counting = (state == COUNT);
    assign done = (counter == 0) && (state == IDLE) && (shift_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            counter <= 0;
            delay <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        counter <= 0;
                    end else begin
                        shift_reg <= {shift_reg[2:0], data};
                    end
                end

                SHIFT: begin
                    if (counter < 3) begin
                        delay <= {delay[2:0], data};
                        counter <= counter + 1;
                    end else begin
                        delay <= {delay[2:0], data};
                        count <= {delay[2:0], data};
                        state <= COUNT;
                        counter <= 0;
                    end
                end

                COUNT: begin
                    if (counter == (delay + 1) * 1000 - 1) begin
                        state <= IDLE;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                        // Update count every 1000 cycles
                        if (counter != 0 && counter % 1000 == 0) begin
                            count <= count - 1;
                        end
                    end
                end
            endcase

            // Handle ack
            if (done && ack) begin
                shift_reg <= 0;
            end
        end
    end

endmodule