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
    reg [7:0] shift_reg;      // Stores both pattern and delay
    reg [15:0] counter;       // Main timing counter
    reg [3:0] delay;          // Captured delay value

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            counter <= 0;
            delay <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[6:0], data};
                    // Detect 1101 followed by 4-bit delay
                    if (shift_reg[6:3] == 4'b1101 && shift_reg[2:0] == 3'b0) begin
                        delay <= shift_reg[7:4];
                        counter <= (shift_reg[7:4] + 1) * 1000;
                        state <= COUNTING;
                    end
                end
                
                COUNTING: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 8'b0;
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        counting = (state == COUNTING);
        done = (state == DONE);
        count = (state == COUNTING) ? ((counter - 1) / 1000) : 4'b0;
    end

endmodule