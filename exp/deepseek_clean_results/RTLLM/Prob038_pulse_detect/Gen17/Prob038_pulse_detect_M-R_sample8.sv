module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE   = 2'b00;
localparam SAW_0  = 2'b01;
localparam SAW_01 = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE:   next_state = (data_in == 0) ? SAW_0 : IDLE;
        SAW_0:  next_state = (data_in == 1) ? SAW_01 : SAW_0;
        SAW_01: next_state = (data_in == 0) ? IDLE : SAW_01;
        default: next_state = IDLE;
    endcase
end

// State register and output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        // Output is high when we complete the 0->1->0 sequence
        data_out <= (state == SAW_01) && (data_in == 0);
    end
end

endmodule