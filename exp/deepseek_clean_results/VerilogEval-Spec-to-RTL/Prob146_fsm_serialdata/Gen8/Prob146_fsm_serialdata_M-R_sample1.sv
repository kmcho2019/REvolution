module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // State encoding
    localparam [1:0] IDLE    = 2'b00;
    localparam [1:0] RECEIVE = 2'b01;
    localparam [1:0] STOP    = 2'b10;

    reg [1:0] current_state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] data_shift_reg;
    reg [7:0] captured_byte;
    reg done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 0;
            data_shift_reg <= 0;
            captured_byte <= 0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    bit_counter <= 0;
                    data_shift_reg <= 0;
                end
                
                RECEIVE: begin
                    data_shift_reg <= {in, data_shift_reg[7:1]};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3'd7) begin
                        captured_byte <= {in, data_shift_reg[7:1]};
                    end
                end
                
                STOP: begin
                    // No state-specific register updates
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:    if (!in) next_state = RECEIVE;
            RECEIVE: if (bit_counter == 3'd7) next_state = STOP;
            STOP:    if (in) next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done_reg <= 0;
        end else begin
            done_reg <= (current_state == STOP) && in && !reset;
        end
    end

    assign out_byte = captured_byte;
    assign done = done_reg;

endmodule