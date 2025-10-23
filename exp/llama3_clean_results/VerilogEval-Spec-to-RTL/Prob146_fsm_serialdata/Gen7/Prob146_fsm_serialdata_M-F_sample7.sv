module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [7:0] shift_reg;
reg [2:0] state_reg; // Increased to 3 bits to accommodate additional states
reg [3:0] counter_reg;

parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;
parameter WAIT_STOP = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter_reg <= 0;
        shift_reg <= 8'b0;
        done <= 0;
    end
    else begin
        case(state_reg)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state_reg <= START;
                    counter_reg <= 0;
                    shift_reg <= 8'b0;
                end
            end
            START: begin
                state_reg <= DATA;
                counter_reg <= 1;
                shift_reg <= {7'b0, in};
            end
            DATA: begin
                if (counter_reg < 8) begin
                    state_reg <= DATA;
                    counter_reg <= counter_reg + 1;
                    shift_reg <= {shift_reg[6:0], in};
                end
                else begin
                    state_reg <= WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in) begin // Stop bit detected
                    state_reg <= IDLE;
                    done <= 1; // Assert done
                end
                else begin // Wait for stop bit
                    state_reg <= WAIT_STOP;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state_reg == IDLE && done) begin
        out_byte <= shift_reg; // Update out_byte when done is asserted
        done <= 0; // Deassert done after out_byte has been updated
    end
end

endmodule