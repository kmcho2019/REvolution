module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk,
    input rst_n // Active low reset
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    HIGH,
    LOW
} state, next_state;

// Initialize state and clock
initial begin
    state = IDLE;
    clk = 1'b0;
end

// Sequential logic for FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        clk <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and clock output
always @(*) begin
    case (state)
        IDLE: begin
            next_state = HIGH;
            clk = 1'b0;
        end
        HIGH: begin
            if (PERIOD / 2 == 5'd0) begin // Half period reached
                next_state = LOW;
            end else begin
                next_state = HIGH;
            end
            clk = 1'b1;
        end
        LOW: begin
            if (PERIOD / 2 == 5'd0) begin // Half period reached
                next_state = IDLE;
            end else begin
                next_state = LOW;
            end
            clk = 1'b0;
        end
        default: begin
            next_state = IDLE;
            clk = 1'b0;
        end
    endcase
end

// Additional logic to handle the clock period
reg [3:0] counter;
always @(posedge clk) begin
    if (state == HIGH || state == LOW) begin
        counter <= counter + 1'b1;
        if (counter == (PERIOD / 2)) begin
            counter <= 4'd0;
        end
    end
end

endmodule