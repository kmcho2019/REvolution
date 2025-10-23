module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte;
reg done;

reg [2:0] state;
reg [2:0] state_next;
reg [3:0] counter;
reg [3:0] counter_next;
reg [7:0] shift_reg;
reg [7:0] shift_reg_next;

always @(*) begin
    case (state)
        3'b000: begin // IDLE
            if (~in) begin
                state_next = 3'b001; // Wait for start bit
                counter_next = 4'b0000;
                shift_reg_next = 8'b00000000;
            end else begin
                state_next = 3'b000;
                counter_next = 4'b0000;
                shift_reg_next = 8'b00000000;
            end
        end
        3'b001: begin // RECEIVE
            if (counter == 4'b1000) begin
                state_next = 3'b010; // Received 8 data bits
                counter_next = 4'b0000;
                shift_reg_next = shift_reg;
            end else begin
                state_next = 3'b001;
                counter_next = counter + 1;
                shift_reg_next = {shift_reg[6:0], in}; // Shift in the new bit
            end
        end
        3'b010: begin // STOP
            if (in) begin
                state_next = 3'b000; // Valid stop bit
                counter_next = 4'b0000;
                shift_reg_next = 8'b00000000;
                done = 1'b1;
            end else begin
                state_next = 3'b010; // Invalid stop bit
                counter_next = 4'b0000;
                shift_reg_next = 8'b00000000;
            end
        end
        default: begin
            state_next = 3'b000;
            counter_next = 4'b0000;
            shift_reg_next = 8'b00000000;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        counter <= 4'b0000;
        shift_reg <= 8'b00000000;
        done <= 1'b0;
    end else begin
        state <= state_next;
        counter <= counter_next;
        shift_reg <= shift_reg_next;
        out_byte <= shift_reg;
        if (state == 3'b010 && in) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule