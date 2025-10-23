module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
typedef enum {Idle, PulseStart, PulseEnd} state_type;
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize current_state to Idle
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= Idle;
        data_out <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            Idle: begin
                if (data_in == 1) begin
                    next_state <= PulseStart;
                    data_out <= 0;
                end else begin
                    next_state <= Idle;
                    data_out <= 0;
                end
            end
            PulseStart: begin
                if (data_in == 0) begin
                    next_state <= PulseEnd;
                    data_out <= 1;
                end else begin
                    next_state <= PulseStart;
                    data_out <= 0;
                end
            end
            PulseEnd: begin
                if (data_in == 1) begin
                    next_state <= PulseStart;
                    data_out <= 0;
                end else begin
                    next_state <= Idle;
                    data_out <= 0;
                end
            end
            default: begin
                next_state <= Idle;
                data_out <= 0;
            end
        endcase
    end
end

endmodule