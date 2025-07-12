module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state = IDLE;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd7)
                        state <= CHECK_STOP;
                end
                CHECK_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                    else
                        state <= WAIT_STOP;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                end
            endcase
        end
    end

    // done asserted only when stop bit is correct in CHECK_STOP state
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule