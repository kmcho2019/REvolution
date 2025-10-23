module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam [1:0] IDLE   = 2'b00;
    localparam [1:0] RECEIVE = 2'b01;
    localparam [1:0] STOP   = 2'b10;
    localparam [1:0] ERROR  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic (combinational)
    wire next_state_idle = (state == IDLE) & in;
    wire next_state_receive = (state == IDLE & ~in) | 
                            (state == RECEIVE & ~(&bit_count));
    wire next_state_stop = (state == RECEIVE & &bit_count);
    wire next_state_error = (state == STOP & ~in) | 
                          (state == ERROR & ~in);

    wire [1:0] next_state = 
        next_state_error ? ERROR :
        next_state_stop ? STOP :
        next_state_receive ? RECEIVE : IDLE;

    // Data register update
    wire data_reg_update = (state == RECEIVE);
    wire [7:0] next_data = data_reg_update ? {in, data_reg[7:1]} : data_reg;

    // Bit counter update
    wire bit_count_inc = (state == RECEIVE);
    wire [2:0] next_bit_count = 
        (state == IDLE) ? 3'b0 :
        bit_count_inc ? bit_count + 1 : bit_count;

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

    // Done signal generation
    assign done = (state == STOP) & in;

endmodule