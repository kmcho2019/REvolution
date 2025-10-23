module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam WAIT_STOP  = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111; // Counts down from 7 to 0
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                data_reg <= {in, data_reg[7:1]}; // LSB first
                bit_count <= bit_count - 1;
            end
        end
    end

    // Combinational logic
    always @(*) begin
        case (state)
            IDLE:      next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE:   next_state = (bit_count == 0) ? WAIT_STOP : RECEIVE;
            WAIT_STOP: next_state = in ? IDLE : WAIT_STOP;
            default:   next_state = IDLE;
        endcase
    end

    assign done = (state == WAIT_STOP) && in;

endmodule