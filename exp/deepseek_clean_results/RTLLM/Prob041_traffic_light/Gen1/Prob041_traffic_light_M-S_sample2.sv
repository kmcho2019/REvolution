module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State parameters
parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;

// Internal registers
reg [1:0] state;
reg [7:0] cnt;

// Combined state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 8'd10;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Default counter decrement
        cnt <= cnt - 1;
        
        // State transitions and counter management
        case (state)
            RED: begin
                if (cnt == 0) begin
                    state <= GREEN;
                    cnt <= 8'd60;
                    red <= 1'b0;
                    green <= 1'b1;
                end
            end
            
            YELLOW: begin
                if (cnt == 0) begin
                    state <= RED;
                    cnt <= 8'd10;
                    yellow <= 1'b0;
                    red <= 1'b1;
                end
            end
            
            GREEN: begin
                // Handle pass_request
                if (pass_request && cnt > 8'd10) begin
                    cnt <= 8'd10;
                end
                
                if (cnt == 0) begin
                    state <= YELLOW;
                    cnt <= 8'd5;
                    green <= 1'b0;
                    yellow <= 1'b1;
                end
            end
        endcase
    end
    
    // Update clock output
    clock <= cnt;
end

endmodule