module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State definitions
    localparam IDLE  = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP  = 2'b10;
    localparam WAIT  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic (continuous assignment style)
    wire [1:0] next_state = 
        (state == IDLE)    ? (~in ? RECEIVE : IDLE) :
        (state == RECEIVE) ? (bit_count == 3'd7 ? STOP : RECEIVE) :
        (state == STOP)    ? (in ? IDLE : WAIT) :
        (state == WAIT)    ? (in ? IDLE : WAIT) :
        IDLE;

    // Data path (combinational)
    wire [7:0] next_data = 
        (state == RECEIVE) ? {in, data_reg[7:1]} : data_reg;

    // Bit counter (combinational)
    wire [2:0] next_bit_count = 
        (state == RECEIVE) ? bit_count + 1 :
        (state == IDLE)    ? 3'd0 :
        bit_count;

    // Done signal (combinational)
    assign done = (state == STOP) & in;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            data_reg <= next_data;
        end
    end

endmodule