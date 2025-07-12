module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding (binary)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;

    // Next state logic
    wire [1:0] next_state;
    assign next_state = 
        (reset) ? IDLE :
        (state == IDLE)    ? (in ? IDLE : RECEIVE) :
        (state == RECEIVE) ? (bit_count == 7 ? STOP : RECEIVE) :
        (state == STOP)    ? (in ? IDLE : WAIT) :
        (state == WAIT)    ? (in ? IDLE : WAIT) :
        IDLE;

    // Shift enable logic
    wire shift_enable;
    assign shift_enable = (state == RECEIVE);

    // Done signal generation
    assign done = (state == STOP) && in;

    // Sequential logic
    always @(posedge clk) begin
        state <= next_state;

        if (reset) begin
            data_reg <= 8'b0;
            bit_count <= 3'b0;
        end else begin
            // Data shift register
            if (shift_enable) begin
                data_reg <= {in, data_reg[7:1]};
            end

            // Bit counter
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

endmodule