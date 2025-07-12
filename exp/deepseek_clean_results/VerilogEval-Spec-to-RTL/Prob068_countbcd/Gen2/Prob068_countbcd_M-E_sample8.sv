module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [1:0] state;
    wire [3:0] next_ones, next_tens, next_hundreds, next_thousands;
    
    // Digit extraction
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    assign q = counter;
    
    // Next digit values
    assign next_ones = (ones == 4'd9) ? 4'd0 : ones + 4'd1;
    assign next_tens = (tens == 4'd9) ? 4'd0 : tens + 4'd1;
    assign next_hundreds = (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
    assign next_thousands = (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
    
    // Enable signals (asserted one cycle before increment)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) & (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) & (tens == 4'd9) & (hundreds == 4'd9);
    
    // State machine
    localparam IDLE = 2'd0;
    localparam INC_ONES = 2'd1;
    localparam INC_TENS = 2'd2;
    localparam INC_HUNDREDS = 2'd3;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    state <= INC_ONES;
                end
                INC_ONES: begin
                    counter[3:0] <= next_ones;
                    if (ones == 4'd9) begin
                        state <= INC_TENS;
                    end else begin
                        state <= IDLE;
                    end
                end
                INC_TENS: begin
                    counter[7:4] <= next_tens;
                    if (tens == 4'd9) begin
                        state <= INC_HUNDREDS;
                    end else begin
                        state <= IDLE;
                    end
                end
                INC_HUNDREDS: begin
                    counter[11:8] <= next_hundreds;
                    if (hundreds == 4'd9) begin
                        counter[15:12] <= next_thousands;
                    end
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule