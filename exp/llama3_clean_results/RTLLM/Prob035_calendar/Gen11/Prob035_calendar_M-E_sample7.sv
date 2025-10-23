module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

// Define the states for the FSM
enum logic [2:0] {IDLE, SEC_INCREMENT, MIN_INCREMENT, HOUR_INCREMENT} state;

// Initialize the counter modules
reg [5:0] sec_counter;
reg [5:0] min_counter;
reg [4:0] hour_counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the counters and FSM state
        sec_counter <= 6'b0;
        min_counter <= 6'b0;
        hour_counter <= 5'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                // Check for seconds increment
                if (sec_counter == 6'd59) begin
                    sec_counter <= 6'b0;
                    state <= SEC_INCREMENT;
                end else begin
                    sec_counter <= sec_counter + 1'b1;
                end
            end
            SEC_INCREMENT: begin
                // Check for minutes increment
                if (min_counter == 6'd59) begin
                    min_counter <= 6'b0;
                    state <= MIN_INCREMENT;
                end else begin
                    min_counter <= min_counter + 1'b1;
                    state <= IDLE;
                end
            end
            MIN_INCREMENT: begin
                // Check for hours increment
                if (hour_counter == 5'd23) begin
                    hour_counter <= 5'b0;
                end else begin
                    hour_counter <= hour_counter + 1'b1;
                end
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Assign the counter values to the output ports
assign Secs = sec_counter;
assign Mins = min_counter;
assign Hours = hour_counter;

endmodule