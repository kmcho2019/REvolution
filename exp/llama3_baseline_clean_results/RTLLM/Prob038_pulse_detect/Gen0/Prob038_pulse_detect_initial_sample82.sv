module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define the states
parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_END = 2'b10;

// Declare the state register
reg [1:0] state;
reg [1:0] next_state;

// Declare the output register
reg data_out_reg;
reg data_out_next;

// Always block for state transitions
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out_reg <= 0;
    end else begin
        state <= next_state;
        data_out_reg <= data_out_next;
    end
end

// Always block for next state and output generation
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_START;
                data_out_next = 0;
            end else begin
                next_state = IDLE;
                data_out_next = 0;
            end
        end
        PULSE_START: begin
            if (~data_in) begin
                next_state = PULSE_END;
                data_out_next = 1;
            end else begin
                next_state = PULSE_START;
                data_out_next = 0;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
            data_out_next = 0;
        end
        default: begin
            next_state = IDLE;
            data_out_next = 0;
        end
    endcase
end

// Continuous assignment for output
assign data_out = data_out_reg;

endmodule