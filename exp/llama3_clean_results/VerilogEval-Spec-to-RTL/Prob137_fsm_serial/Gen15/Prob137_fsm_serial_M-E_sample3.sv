module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Bit Synchronization Module
module bit_sync(
    input clk,
    input reset,
    input in,
    output reg start_bit
);
reg [1:0] sync_state;
reg [2:0] sync_counter;

always @(posedge clk) begin
    if (reset) begin
        sync_state <= 2'b00;
        sync_counter <= 3'b0;
    end else begin
        case (sync_state)
            2'b00: begin // IDLE
                if (~in) begin // Start bit detected
                    sync_state <= 2'b01;
                    sync_counter <= 3'b1;
                end
            end
            2'b01: begin // START_BIT
                if (in) begin // Stop bit detected
                    sync_state <= 2'b00;
                end else begin
                    sync_counter <= sync_counter + 1;
                    if (sync_counter == 3'b8) begin // 8 bits received
                        start_bit <= 1'b1;
                    end
                end
            end
        endcase
    end
end

endmodule

// Byte Reception Module
module byte_rx(
    input clk,
    input reset,
    input in,
    input start_bit,
    output reg byte_done
);
reg [7:0] byte;
reg [2:0] rx_counter;

always @(posedge clk) begin
    if (reset) begin
        byte <= 8'b0;
        rx_counter <= 3'b0;
        byte_done <= 1'b0;
    end else begin
        if (start_bit) begin
            byte <= {byte[6:0], in};
            rx_counter <= rx_counter + 1;
            if (rx_counter == 3'b8) begin // 8 bits received
                if (in) begin // Stop bit correct
                    byte_done <= 1'b1;
                end
                rx_counter <= 3'b0;
            end
        end
    end
end

endmodule

// Finite State Machine (FSM)
reg [1:0] fsm_state;
reg start_bit;
reg byte_done;

bit_sync u_bit_sync(
    .clk(clk),
    .reset(reset),
    .in(in),
    .start_bit(start_bit)
);

byte_rx u_byte_rx(
    .clk(clk),
    .reset(reset),
    .in(in),
    .start_bit(start_bit),
    .byte_done(byte_done)
);

always @(posedge clk) begin
    if (reset) begin
        fsm_state <= 2'b00;
        done <= 1'b0;
    end else begin
        case (fsm_state)
            2'b00: begin // IDLE
                if (start_bit) begin
                    fsm_state <= 2'b01;
                end
            end
            2'b01: begin // RECEIVE
                if (byte_done) begin
                    fsm_state <= 2'b00;
                    done <= 1'b1;
                end
            end
        endcase
    end
end

endmodule