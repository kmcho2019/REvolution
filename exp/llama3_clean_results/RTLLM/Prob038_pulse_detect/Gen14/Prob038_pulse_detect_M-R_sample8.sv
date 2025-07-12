module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam S_IDLE = 2'b00;
localparam S_RISING = 2'b01;
localparam S_FALLING = 2'b10;

reg [1:0] state; // State register
reg [1:0] next_state; // Next state register

// Combinational logic for next state and output
assign data_out = (state == S_FALLING) ? 1'b1 : 1'b0;

always @(*) begin
    case (state)
        S_IDLE: begin
            if (data_in) begin
                next_state = S_RISING;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_RISING: begin
            if (!data_in) begin
                next_state = S_FALLING;
            end else begin
                next_state = S_RISING;
            end
        end
        S_FALLING: begin
            next_state = S_IDLE;
        end
        default: next_state = S_IDLE;
    endcase
end

// Update state register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule