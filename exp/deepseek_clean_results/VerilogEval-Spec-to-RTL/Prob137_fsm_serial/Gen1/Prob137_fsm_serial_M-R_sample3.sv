module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // States
    localparam IDLE  = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        bit_cnt <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_cnt == 3'd7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                
                STOP: begin
                    if (in)  // Valid stop bit
                        state <= IDLE;
                    // Else stay in STOP until we see stop bit
                end
            endcase
        end
    end

    // Output logic (done pulses when valid stop bit detected)
    assign done = (state == STOP) && in;

endmodule