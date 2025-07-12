module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State definitions
    localparam IDLE  = 2'b00;
    localparam RECV  = 2'b01;
    localparam STOP  = 2'b10;
    localparam WAIT  = 2'b11;

    reg [1:0] state;
    reg [3:0] bit_count;  // Using bit_count[3] as terminal condition
    reg [7:0] shift_reg;

    // Combined state transition and register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (~in) state <= RECV;  // Start bit detected
                end

                RECV: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                    if (bit_count[3]) state <= STOP;  // All 8 bits received
                end

                STOP: begin
                    if (in) state <= IDLE;    // Valid stop bit
                    else state <= WAIT;       // Missing stop bit
                end

                WAIT: begin
                    if (in) state <= IDLE;    // Line returned to idle
                end
            endcase
        end
    end

    // Done signal is high when we're in STOP state and in=1
    assign done = (state == STOP) & in;

endmodule