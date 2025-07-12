module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] bcd_reg;
    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] delay_counter;
    
    // State definitions
    localparam IDLE        = 3'b000;
    localparam INC_ONES    = 3'b001;
    localparam INC_TENS    = 3'b010;
    localparam INC_HUNDREDS = 3'b011;
    localparam INC_THOUSANDS = 3'b100;
    
    assign q = bcd_reg;
    
    // Enable signals based on state transitions
    assign ena[0] = (state == INC_TENS);
    assign ena[1] = (state == INC_HUNDREDS);
    assign ena[2] = (state == INC_THOUSANDS);
    
    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = (delay_counter == 4'd9) ? INC_ONES : IDLE;
            INC_ONES: begin
                if (bcd_reg[3:0] == 4'd9) begin
                    next_state = INC_TENS;
                end else begin
                    next_state = IDLE;
                end
            end
            INC_TENS: begin
                if (bcd_reg[7:4] == 4'd9) begin
                    next_state = INC_HUNDREDS;
                end else begin
                    next_state = IDLE;
                end
            end
            INC_HUNDREDS: begin
                if (bcd_reg[11:8] == 4'd9) begin
                    next_state = INC_THOUSANDS;
                end else begin
                    next_state = IDLE;
                end
            end
            INC_THOUSANDS: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Main sequential logic
    always @(posedge clk) begin
        if (reset) begin
            bcd_reg <= 16'd0;
            state <= IDLE;
            delay_counter <= 4'd0;
        end else begin
            state <= next_state;
            
            // Delay counter for ones digit increment rate
            if (state == IDLE) begin
                delay_counter <= delay_counter + 4'd1;
            end else begin
                delay_counter <= 4'd0;
            end
            
            // Digit increment logic based on state
            case (state)
                INC_ONES: begin
                    if (bcd_reg[3:0] == 4'd9) begin
                        bcd_reg[3:0] <= 4'd0;
                    end else begin
                        bcd_reg[3:0] <= bcd_reg[3:0] + 4'd1;
                    end
                end
                INC_TENS: begin
                    if (bcd_reg[7:4] == 4'd9) begin
                        bcd_reg[7:4] <= 4'd0;
                    end else begin
                        bcd_reg[7:4] <= bcd_reg[7:4] + 4'd1;
                    end
                end
                INC_HUNDREDS: begin
                    if (bcd_reg[11:8] == 4'd9) begin
                        bcd_reg[11:8] <= 4'd0;
                    end else begin
                        bcd_reg[11:8] <= bcd_reg[11:8] + 4'd1;
                    end
                end
                INC_THOUSANDS: begin
                    if (bcd_reg[15:12] == 4'd9) begin
                        bcd_reg[15:12] <= 4'd0;
                    end else begin
                        bcd_reg[15:12] <= bcd_reg[15:12] + 4'd1;
                    end
                end
            endcase
        end
    end

endmodule