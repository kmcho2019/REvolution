module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states
reg [1:0] current_state;

// Initial state
initial current_state = 2'b00;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= 2'b00;
    end else begin
        case (current_state)
            2'b00: begin
                if (data_in == 1'b1)
                    current_state <= 2'b01;
                else
                    current_state <= 2'b00;
            end
            2'b01: begin
                if (data_in == 1'b0)
                    current_state <= 2'b10;
                else
                    current_state <= 2'b00;
            end
            2'b10: begin
                if (data_in == 1'b0)
                    current_state <= 2'b10;
                else
                    current_state <= 2'b11;
            end
            2'b11: begin
                if (data_in == 1'b1)
                    current_state <= 2'b00;
                else
                    current_state <= 2'b00;
            end
            default: current_state <= 2'b00;
        endcase
    end
end

// Sequence detection output logic
assign sequence_detected = (current_state == 2'b11) ? 1'b1 : 1'b0;

endmodule