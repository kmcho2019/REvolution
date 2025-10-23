module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [7:0] data_reg;
    
    // Next state logic (continuous assignment style)
    wire [1:0] next_state = 
        (state == IDLE)    ? (in ? IDLE : RECEIVE) :
        (state == RECEIVE) ? (bit_count == 3'b111 ? STOP : RECEIVE) :
        (state == STOP)    ? (in ? IDLE : WAIT) :
        (state == WAIT)    ? (in ? IDLE : WAIT) :
        IDLE;  // default
    
    // Bit counter
    wire [2:0] bit_count = (state == RECEIVE) ? bit_count_reg + 1 : 3'b0;
    reg [2:0] bit_count_reg;
    
    // Shift enable and done signals
    wire shift_enable = (state == RECEIVE);
    assign done = (state == STOP) && in;
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            bit_count_reg <= 3'b0;
        end else begin
            state <= next_state;
            bit_count_reg <= bit_count;
            
            if (shift_enable) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
            end
        end
    end

endmodule