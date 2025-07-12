module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding with descriptive names
    localparam IDLE    = 2'b00;  // Waiting for start bit
    localparam RECEIVE = 2'b01;  // Receiving data bits
    localparam STOP    = 2'b10;  // Checking stop bit
    localparam WAIT    = 2'b11;  // Waiting for line to return to idle

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Single always block for state machine and data handling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                    end
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift in LSB first
                    bit_count <= bit_count + 1;
                    if (bit_count == 7) begin  // Received all 8 bits
                        state <= STOP;
                    end
                end

                STOP: begin
                    if (in) begin  // Valid stop bit
                        state <= IDLE;
                    end else begin
                        state <= WAIT;
                    end
                end

                WAIT: begin
                    if (in) begin  // Line returned to idle
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Combinational output logic
    assign done = (state == STOP) && in;  // Assert done only when valid stop bit

endmodule