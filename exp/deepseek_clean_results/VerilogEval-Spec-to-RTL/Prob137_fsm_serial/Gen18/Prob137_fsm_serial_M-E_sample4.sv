module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // States
    localparam IDLE = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam VALIDATING = 2'b10;

    reg [1:0] state;
    reg [9:0] shift_reg;  // Stores start + 8 data + stop bits
    reg [3:0] timeout;
    reg in_prev;

    // Edge detection
    wire start_edge = (in_prev && ~in);

    // Timeout condition (10 cycles max for full byte + stop bit)
    wire timeout_expired = (timeout == 4'd10);

    // Shift register control
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b0;
            in_prev <= 1'b1;
        end else begin
            in_prev <= in;
            if (state != IDLE) begin
                shift_reg <= {in, shift_reg[9:1]};  // Shift in new bit
            end
        end
    end

    // Timeout counter
    always @(posedge clk) begin
        if (reset || state == IDLE) begin
            timeout <= 4'b0;
        end else begin
            timeout <= timeout + 1;
        end
    end

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: 
                    if (start_edge) state <= RECEIVING;
                RECEIVING:
                    if (timeout_expired) state <= VALIDATING;
                VALIDATING:
                    if (shift_reg[9] == 1'b0 || shift_reg[0] == 1'b1)
                        state <= IDLE;
            endcase
        end
    end

    // Done signal (combinational)
    assign done = (state == VALIDATING) && 
                  (shift_reg[9] == 1'b0) &&  // Valid start bit
                  (shift_reg[0] == 1'b1);   // Valid stop bit

endmodule