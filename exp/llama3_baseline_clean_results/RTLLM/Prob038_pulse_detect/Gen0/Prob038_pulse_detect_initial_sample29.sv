module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam FALLING = 2'b10;

// Register to keep track of the current state
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        IDLE: begin
            if (data_in) begin
                next_state = RISING;
            end else begin
                next_state = IDLE;
            end
        end
        RISING: begin
            if (!data_in) begin
                next_state = FALLING;
            end else begin
                next_state = RISING;
            end
        end
        FALLING: begin
            if (!data_in) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic to update the state and output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING &&!data_in) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

endmodule