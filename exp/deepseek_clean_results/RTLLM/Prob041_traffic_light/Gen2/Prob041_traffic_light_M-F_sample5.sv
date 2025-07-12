module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [6:0] clock,  // Reduced to 7 bits
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;

reg [1:0] state;
reg [6:0] cnt;  // Reduced to 7 bits

// Single always block for state and counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 7'd10;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Handle pedestrian request during green
        if (pass_request && (state == GREEN) && (cnt > 7'd10)) begin
            cnt <= 7'd10;
        end
        
        // Countdown and state transitions
        if (cnt > 7'd1) begin
            cnt <= cnt - 7'd1;
            /* For power optimization:
            if (cnt == 7'd1) begin
                // Enable clock gating here if needed
            end
            */
        end else begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= 7'd60;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= 7'd10;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= 7'd5;
                end
            endcase
        end
        
        // Output assignments
        red <= (state == RED);
        yellow <= (state == YELLOW);
        green <= (state == GREEN);
        clock <= cnt;
    end
end

endmodule