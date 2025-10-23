module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [2:0] bit_count;
    reg [15:0] counter; // Sufficient for max 16*1000 cycles

    // Output assignments
    assign counting = (state == COUNT);
    assign done = (state == COUNT) && (counter == 0);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 0;
            delay <= 0;
            bit_count <= 0;
            counter <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= LOAD;
                        bit_count <= 0;
                    end
                end

                LOAD: begin
                    if (bit_count < 4) begin
                        delay <= {delay[2:0], data};
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= COUNT;
                        counter <= (delay + 1) * 1000;
                    end
                end

                COUNT: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                        count <= (counter / 1000) - 1;
                    end else if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule