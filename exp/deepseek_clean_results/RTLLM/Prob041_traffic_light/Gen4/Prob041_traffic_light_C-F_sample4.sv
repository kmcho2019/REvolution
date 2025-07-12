module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
localparam [1:0]
    IDLE   = 2'b00,
    RED    = 2'b01,
    YELLOW = 2'b10,
    GREEN  = 2'b11;

reg [1:0] state;
reg [7:0] counter;
reg r_red, r_yellow, r_green;

// Unified state machine and timing control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= RED_TIME;
        r_red <= 1'b0;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
    end else begin
        // Default light outputs
        r_red <= 1'b0;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
        
        case (state)
            IDLE: begin
                state <= RED;
                counter <= RED_TIME;
                r_red <= 1'b1;
            end
            
            RED: begin
                r_red <= 1'b1;
                if (counter == 1) begin
                    state <= GREEN;
                    counter <= GREEN_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            YELLOW: begin
                r_yellow <= 1'b1;
                if (counter == 1) begin
                    state <= RED;
                    counter <= RED_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            GREEN: begin
                r_green <= 1'b1;
                // Handle pedestrian request
                if (pass_request && (counter > MIN_GREEN)) begin
                    counter <= MIN_GREEN;
                end else if (counter == 1) begin
                    state <= YELLOW;
                    counter <= YELLOW_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

// Output assignments
assign clock = counter;
assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;

endmodule