module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;
    wire receive_clk_en;

    // Gray code counter for bit_count
    wire [2:0] next_bit_count = (state == RECEIVE) ? 
                               {bit_count[2] ^ (&bit_count[1:0]),
                                bit_count[1] ^ bit_count[0],
                                ~bit_count[0]} : 
                               3'b0;

    // Clock gating for data register
    assign receive_clk_en = (state == RECEIVE);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            done_reg <= (state == STOP) & in;
        end
    end

    // Data register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (receive_clk_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // Optimized combinational next state logic
    always @(*) begin
        case (1'b1)  // synthesis parallel_case
            state[0]: next_state = (~in) ? RECEIVE : IDLE;  // IDLE
            state[1]: next_state = (&bit_count) ? STOP : RECEIVE;  // RECEIVE
            state[2]: next_state = in ? IDLE : WAIT;  // STOP
            state[3]: next_state = in ? IDLE : WAIT;  // WAIT
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule