module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded states (4 bits, only one bit high at a time)
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP      = 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic using continuous assignments
    wire idle = state[0];
    wire receive = state[1];
    wire stop = state[2];
    wire wait_stop = state[3];

    assign next_state = 
        idle      ? ((in == 1'b0) ? RECEIVE   : IDLE)       :
        receive   ? ((bit_count == 3'd7) ? STOP : RECEIVE) :
        stop      ? ((in == 1'b1) ? IDLE : WAIT_STOP)      :
        wait_stop ? ((in == 1'b1) ? IDLE : WAIT_STOP)      :
        IDLE; // Default fallback

    // Bit counter logic
    always @(posedge clk) begin
        if (reset || state == IDLE)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 1;
    end

    // Data shift register (LSB first)
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == RECEIVE)
            data_shift <= {data_shift[6:0], in};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Done pulse generation: asserted one cycle when STOP state and stop bit valid
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == STOP) && (in == 1'b1);
    end

endmodule