module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
parameter IDLE = 2'b00;
parameter GOT_1 = 2'b01;
parameter GOT_0 = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = data_in ? GOT_1 : IDLE;
        GOT_1: next_state = data_in ? GOT_1 : GOT_0;
        GOT_0: next_state = data_in ? GOT_1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        data_out <= (state == GOT_1 && !data_in);
    end
end

endmodule