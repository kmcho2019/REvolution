module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // State encoding using parameters
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: 
                next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: 
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP: 
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default: 
                next_state = IDLE;
        endcase
    end

    // Shift register and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // LSB first reception
                    bit_count <= bit_count + 1;
                end
                CHECK_STOP, WAIT_STOP: begin
                    bit_count <= 3'd0;
                end
                default: begin
                    shift_reg <= shift_reg;
                    bit_count <= bit_count;
                end
            endcase
        end
    end

    // done is combinational: high only for one cycle when stop bit is valid at CHECK_STOP
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule