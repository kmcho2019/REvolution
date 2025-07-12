module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Parameters for timing
parameter RED_TIME    = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME  = 8'd60;
parameter REQ_TIME    = 8'd10;

// State encoding
localparam [1:0] 
    ST_IDLE   = 2'b00,
    ST_RED    = 2'b01,
    ST_YELLOW = 2'b10,
    ST_GREEN  = 2'b11;

reg [1:0] state;
reg [7:0] counter;

// State machine and timing control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= ST_IDLE;
        counter <= RED_TIME;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= RED_TIME;
    end else begin
        case (state)
            ST_IDLE: begin
                state <= ST_RED;
                counter <= RED_TIME;
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
                clock <= RED_TIME;
            end
            
            ST_RED: begin
                if (counter == 0) begin
                    state <= ST_GREEN;
                    counter <= GREEN_TIME;
                    red <= 1'b0;
                    green <= 1'b1;
                    clock <= GREEN_TIME;
                end else begin
                    counter <= counter - 1;
                    clock <= counter - 1;
                end
            end
            
            ST_YELLOW: begin
                if (counter == 0) begin
                    state <= ST_RED;
                    counter <= RED_TIME;
                    yellow <= 1'b0;
                    red <= 1'b1;
                    clock <= RED_TIME;
                end else begin
                    counter <= counter - 1;
                    clock <= counter - 1;
                end
            end
            
            ST_GREEN: begin
                // Handle pedestrian request
                if (pass_request && (counter > REQ_TIME)) begin
                    counter <= REQ_TIME;
                    clock <= REQ_TIME;
                end else if (counter == 0) begin
                    state <= ST_YELLOW;
                    counter <= YELLOW_TIME;
                    green <= 1'b0;
                    yellow <= 1'b1;
                    clock <= YELLOW_TIME;
                end else begin
                    counter <= counter - 1;
                    clock <= counter - 1;
                end
            end
            
            default: begin
                state <= ST_IDLE;
                counter <= RED_TIME;
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
                clock <= RED_TIME;
            end
        endcase
    end
end

endmodule