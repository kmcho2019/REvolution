module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states - optimized 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    // Bit counter constants
    localparam BIT_COUNT_INIT = 3'b111;
    localparam BIT_COUNT_DONE = 3'b000;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;  // Clock gating control

    // Combinatorial done signal
    assign done = (state == STOP) && (in == 1);

    // Clock gating for shift register
    always @(posedge clk) begin
        if (shift_enable)
            shift_reg <= {in, shift_reg[7:1]}; // LSB first
    end

    // Main FSM - optimized for timing and power
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= BIT_COUNT_INIT;
            out_byte <= 0;
            shift_enable <= 0;
        end else begin
            shift_enable <= 0;  // Default disabled

            case (state)
                IDLE: begin
                    if (in == 0) begin // Start bit detected
                        state <= RECEIVE;
                        bit_count <= BIT_COUNT_INIT;
                        shift_enable <= 1; // Enable shift on first bit
                    end
                end
                
                RECEIVE: begin
                    shift_enable <= 1; // Enable shift register
                    if (bit_count == BIT_COUNT_DONE) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in == 1) begin // Valid stop bit
                        out_byte <= shift_reg; // Parallel load
                        state <= IDLE;
                    end else begin // Missing stop bit
                        state <= IDLE; // Merged ERROR behavior
                    end
                end
            endcase
        end
    end

endmodule