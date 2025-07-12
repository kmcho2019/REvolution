module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state, next_state;
reg data_in_prev;

// State encoding
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_in_prev <= 0;
        data_out <= 0;
    end else begin
        data_in_prev <= data_in;
        state <= next_state;
        
        // Output is high only when we detect the falling edge after GOT_1 state
        data_out <= (state == GOT_1) && data_in_prev && !data_in;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (!data_in) next_state = GOT_0;
            else next_state = IDLE;
        end
        GOT_0: begin
            if (data_in) next_state = GOT_1;
            else next_state = GOT_0;
        end
        GOT_1: begin
            if (!data_in) next_state = IDLE;
            else next_state = GOT_1;
        end
        default: next_state = IDLE;
    endcase
end

endmodule