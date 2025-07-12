module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // FSM state register
reg [1:0] counter; // Counter for clock cycles

// FSM states
parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_COUNTING = 2'b10;
parameter PULSE_END = 2'b11;

// Sequential logic for FSM and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
        counter <= 2'b00;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin // Low-to-high transition
                    state <= PULSE_START;
                    counter <= 2'b01;
                end
            end
            PULSE_START: begin
                if (data_in == 1'b1) begin // Continue counting
                    state <= PULSE_COUNTING;
                    counter <= counter + 1'b1;
                end else begin // Not a pulse, revert to IDLE
                    state <= IDLE;
                end
            end
            PULSE_COUNTING: begin
                if (data_in == 1'b1) begin // Continue counting
                    counter <= counter + 1'b1;
                end else begin // Pulse ended, check count
                    state <= PULSE_END;
                end
            end
            PULSE_END: begin
                if (counter >= 2'b10) begin // Valid pulse, set data_out to 1
                    data_out <= 1'b1;
                end
                state <= IDLE; // Reset FSM
                counter <= 2'b00;
            end
        endcase
    end
end

// Combinational logic to reset data_out
always @(posedge clk) begin
    if (state != PULSE_END) begin
        data_out <= 1'b0;
    end
end

endmodule