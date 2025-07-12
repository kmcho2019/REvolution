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
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;
    
    reg [1:0] state;
    reg [3:0] pattern;
    reg [2:0] bit_cnt;
    reg [13:0] counter;
    reg [13:0] target;
    reg [3:0] delay;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            bit_cnt <= 0;
            counter <= 0;
            target <= 0;
            delay <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= LOAD;
                        bit_cnt <= 0;
                    end
                end
                
                LOAD: begin
                    delay <= {delay[2:0], data};
                    if (bit_cnt == 3) begin
                        target <= (delay[2:0] + 1) * 1000;
                        counter <= 0;
                        state <= COUNT;
                    end
                    bit_cnt <= bit_cnt + 1;
                end
                
                COUNT: begin
                    if (counter == target - 1) begin
                        state <= DONE;
                    end
                    counter <= counter + 1;
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        counting = (state == COUNT);
        done = (state == DONE);
        count = (state == COUNT) ? (target - counter - 1) / 1000 : 4'b0;
    end

endmodule