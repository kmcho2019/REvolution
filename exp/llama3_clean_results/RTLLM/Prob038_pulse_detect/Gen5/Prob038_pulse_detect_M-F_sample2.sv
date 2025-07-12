module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] state; // One-hot encoded FSM: IDLE, RISING, FALLING
reg [2:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b001; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (data_in) begin
                    next_state = 3'b010; // RISING state
                end else begin
                    next_state = 3'b001; // IDLE state
                end
            end
            3'b010: begin // RISING state
                if (!data_in) begin
                    next_state = 3'b100; // FALLING state
                end else begin
                    next_state = 3'b010; // RISING state
                end
            end
            3'b100: begin // FALLING state
                if (!data_in) begin
                    next_state = 3'b001; // IDLE state
                    data_out <= 1; // Pulse detected
                end else begin
                    next_state = 3'b010; // RISING state
                    data_out <= 0;
                end
            end
            default: next_state = 3'b001; // IDLE state
        endcase
        state <= next_state;
        if (state != 3'b100 || data_in) begin
            data_out <= 0; // Reset data_out if not in FALLING state or data_in is high
        end
    end
end

endmodule