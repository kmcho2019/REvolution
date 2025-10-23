module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
localparam IDLE  = 2'b00;
localparam GOT_1 = 2'b01;
localparam GOT_10 = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = data_in ? GOT_1 : IDLE;
        GOT_1: next_state = data_in ? GOT_1 : GOT_10;
        GOT_10: next_state = data_in ? GOT_1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Output is combinatorial
assign data_out = (state == GOT_10);

endmodule