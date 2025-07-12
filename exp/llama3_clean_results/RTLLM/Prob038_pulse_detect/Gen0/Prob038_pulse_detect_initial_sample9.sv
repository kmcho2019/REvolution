module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states
parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_END = 2'b10;

// Declare the state register
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic for next state and output signal
always @(*) begin
    case(state)
        IDLE: begin
            if(data_in) begin
                next_state = PULSE_START;
                data_out = 0;
            end else begin
                next_state = IDLE;
                data_out = 0;
            end
        end
        PULSE_START: begin
            if(!data_in) begin
                next_state = PULSE_END;
                data_out = 0;
            end else begin
                next_state = PULSE_START;
                data_out = 0;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
            data_out = 1;
        end
        default: begin
            next_state = IDLE;
            data_out = 0;
        end
    endcase
end

// Sequential logic for current state
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
    end
end

endmodule