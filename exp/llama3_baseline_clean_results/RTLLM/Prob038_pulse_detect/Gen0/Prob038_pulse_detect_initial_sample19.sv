module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the finite state machine
localparam IDLE = 2'b00;
localparam RISE = 2'b01;
localparam FALL = 2'b10;

reg [1:0] state, next_state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine to the IDLE state
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        // Set data_out to 1 when in the FALL state and data_in is 0
        if (state == FALL && data_in == 0) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

always @ (*) begin
    case (state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = RISE;
            end else begin
                next_state = IDLE;
            end
        end
        RISE: begin
            if (data_in == 0) begin
                next_state = FALL;
            end else begin
                next_state = RISE;
            end
        end
        FALL: begin
            if (data_in == 0) begin
                next_state = IDLE;
            end else begin
                next_state = RISE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule