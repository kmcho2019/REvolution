module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [3:0] counter; // Increased counter width to 4 bits
reg [7:0] data_reg;
reg [1:0] state_reg;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter <= 4'b0000;
        data_reg <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state_reg)
            IDLE: begin
                if (!in) begin // Wait for start bit (0)
                    state_reg <= START;
                end
            end
            START: begin
                if (!in) begin // Verify start bit
                    state_reg <= DATA;
                    counter <= 4'b0001;
                    data_reg <= {7'b0, in}; // Store the start bit
                end
                else begin // Invalid start bit, stay in IDLE
                    state_reg <= IDLE;
                end
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in}; // Shift in the data bit
                counter <= counter + 1;
                if (counter == 4'd9) begin // 8 data bits received
                    state_reg <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Verify stop bit (1)
                    done <= 1;
                    out_byte <= data_reg[7:0]; // Update out_byte with the received byte
                end
                else begin // Invalid stop bit, wait for a stop bit
                    state_reg <= IDLE;
                end
                state_reg <= IDLE; // Transition to IDLE regardless of stop bit verification
            end
        endcase
    end
end

// Added a small delay to ensure done signal stays high for at least one clock cycle
always @(posedge clk) begin
    if (state_reg == STOP && in) begin
        done <= 1;
    end
    else if (state_reg!= STOP || in == 0) begin
        done <= 0;
    end
end

endmodule