module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
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
localparam [1:0] IDLE  = 2'b00;
localparam [1:0] RED   = 2'b01;
localparam [1:0] YELLOW = 2'b10;
localparam [1:0] GREEN = 2'b11;

reg [1:0] state;
reg [5:0] cnt;

// Output assignments
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

// Combined state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
    end else begin
        case (state)
            IDLE: begin
                state <= RED;
                cnt <= RED_TIME;
            end
            
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN: begin
                // Handle pedestrian request
                if (pass_request && (cnt > MIN_GREEN)) begin
                    cnt <= MIN_GREEN;
                end
                
                if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

endmodule