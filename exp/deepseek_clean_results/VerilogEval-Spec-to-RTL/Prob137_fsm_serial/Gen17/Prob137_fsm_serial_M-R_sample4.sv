module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot encoded states (4 bits)
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    
    // Combinational signals
    wire count_complete = (bit_count == 3'b111);
    wire shift_enable = (state == RECEIVE);
    wire valid_stop = (state == STOP) && in;
    wire invalid_stop = (state == STOP) && ~in;
    
    // Next state logic (combinational)
    wire [3:0] next_state;
    assign next_state = reset ? IDLE : 
                       (state == IDLE)    ? (in ? IDLE : RECEIVE) :
                       (state == RECEIVE) ? (count_complete ? STOP : RECEIVE) :
                       (state == STOP)    ? (in ? IDLE : WAIT) :
                       (state == WAIT)    ? (in ? IDLE : WAIT) :
                       IDLE;  // default
    
    // Data shift register (LSB first)
    always @(posedge clk) begin
        if (shift_enable) begin
            data_reg <= {in, data_reg[7:1]};
        end
    end
    
    // Sequential logic
    always @(posedge clk) begin
        state <= next_state;
        
        if (reset) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'b0;
        end
    end
    
    // Done signal (single cycle pulse)
    assign done = valid_stop;

endmodule