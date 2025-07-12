module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam IDLE      = 1'b0;
localparam GOT_RISE  = 1'b1;

reg state, next_state;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = (data_in == 1) ? GOT_RISE : IDLE;
        end
        GOT_RISE: begin
            next_state = (data_in == 0) ? IDLE : GOT_RISE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
    end else begin
        data_out <= (state == GOT_RISE && data_in == 0) ? 1'b1 : 1'b0;
    end
end

endmodule