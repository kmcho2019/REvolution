module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state, next_state;
reg data_in_prev;

// State encoding
localparam IDLE     = 2'b00;
localparam GOT_RISE = 2'b01;
localparam GOT_FALL = 2'b10;

// Edge detection
wire rising_edge = ~data_in_prev & data_in;
wire falling_edge = data_in_prev & ~data_in;

// Next state logic (combinational)
always @(*) begin
    case (state)
        IDLE:     next_state = rising_edge ? GOT_RISE : IDLE;
        GOT_RISE: next_state = falling_edge ? GOT_FALL : 
                              rising_edge ? GOT_RISE : GOT_RISE;
        GOT_FALL: next_state = IDLE;
        default:  next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_in_prev <= 1'b0;
        data_out <= 1'b0;
    end else begin
        data_in_prev <= data_in;
        state <= next_state;
        
        // Output is high only in GOT_FALL state
        data_out <= (next_state == GOT_FALL);
    end
end

endmodule