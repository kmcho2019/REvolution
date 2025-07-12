module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam PULSE_START = 2'b01;
localparam PULSE_END = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

// Implement the FSM logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1) begin
                    state <= PULSE_START;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_START: begin
                if (data_in == 1) begin
                    state <= PULSE_START;
                    data_out <= 0;
                end else begin
                    state <= PULSE_END;
                    data_out <= 1;
                end
            end
            PULSE_END: begin
                if (data_in == 0) begin
                    state <= IDLE;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule