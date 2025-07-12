module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // States
    localparam IDLE    = 2'b00;
    localparam DETECT  = 2'b01;
    localparam CAPTURE = 2'b10;
    localparam COUNT   = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [15:0] main_counter; // Enough for max delay (15+1)*1000 = 16000
    reg [3:0] delay_value;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            main_counter <= 0;
            delay_value <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= DETECT;
                        bit_count <= 0;
                    end
                end

                DETECT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3) begin
                        delay_value <= shift_reg;
                        main_counter <= (shift_reg + 1) * 1000;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    if (main_counter == 0) begin
                        state <= IDLE;
                    end else begin
                        main_counter <= main_counter - 1;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign counting = (state == COUNT);
    assign done = (main_counter == 0) && (state == COUNT);
    assign count = (state == COUNT) ? (main_counter / 1000) : 4'b0;

endmodule