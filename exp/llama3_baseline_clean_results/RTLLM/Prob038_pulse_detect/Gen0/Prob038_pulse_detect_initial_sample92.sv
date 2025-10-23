module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Declare the states
localparam IDLE = 2'b00;
localparam PULSE_START = 2'b01;
localparam PULSE_END = 2'b10;

// Declare the state register
reg [1:0] state;
reg [1:0] next_state;

// Always block for state register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        if (state == PULSE_END) begin
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

// Always block for next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_START;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_START: begin
            if (~data_in) begin
                next_state = PULSE_END;
            end else begin
                next_state = PULSE_START;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule