module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        // Output logic: pulse only when we complete the sequence
        data_out <= (state == GOT_1 && !data_in) ? 1'b1 : 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = data_in ? IDLE : GOT_0;
        end
        GOT_0: begin
            next_state = data_in ? GOT_1 : GOT_0;
        end
        GOT_1: begin
            next_state = data_in ? IDLE : IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule