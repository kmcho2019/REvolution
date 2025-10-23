module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding (same binary encoding)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic (combinational using assign)
    wire [1:0] next_state = 
        (state == IDLE)    ? (in ? IDLE : RECEIVE) :
        (state == RECEIVE) ? (bit_count == 3'b111 ? STOP : RECEIVE) :
        (state == STOP)    ? (in ? IDLE : WAIT) :
        (state == WAIT)    ? (in ? IDLE : WAIT) :
        IDLE;  // Default

    // Shift register enable
    wire shift_enable = (state == RECEIVE);

    // Done signal (combinational)
    assign done = (state == STOP) && in;

    // Sequential logic for state and bit counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            bit_count <= (state == RECEIVE) ? bit_count + 1 : 3'b0;
        end
    end

    // Shift register (LSB first)
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (shift_enable) begin
            data_reg <= {in, data_reg[7:1]};
        end
    end

endmodule