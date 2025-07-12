module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

parameter SEQUENCE_BITS = 4;
parameter DELAY_BITS = 4;

reg [SEQUENCE_BITS-1:0] seq_reg;
reg [DELAY_BITS-1:0] delay_reg;
reg [19:0] counter;
reg [SEQUENCE_BITS-1:0] shift_counter;
reg [1:0] state;

assign counting = (state == 2) ? 1'b1 : 1'b0;
assign done = (state == 3) ? 1'b1 : 1'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay_reg <= 0;
        counter <= 0;
        shift_counter <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                // Search for the input sequence 1101
                seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                    shift_counter <= 0;
                end
            end
            1: begin // SHIFT
                // Shift in the next 4 bits to determine the delay duration
                delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
                shift_counter <= shift_counter + 1;
                if (shift_counter == DELAY_BITS - 1) begin
                    state <= 2;
                end
            end
            2: begin // COUNT
                // Count up to the desired number of clock cycles
                counter <= counter + 1;
                if (counter % 1000 == 0 && counter != 0) begin
                    count <= count - 1;
                end
                if (counter >= (delay_reg + 1) * 1000 - 1) begin
                    state <= 3;
                end
            end
            3: begin // DONE
                // Wait for the ack signal to reset the state machine
                if (ack == 1'b1) begin
                    state <= 4;
                end
            end
            4: begin // ACK
                // Reset the state machine
                state <= 0;
                seq_reg <= 0;
                delay_reg <= 0;
                counter <= 0;
                shift_counter <= 0;
                count <= delay_reg;
            end
        endcase
    end
end

endmodule