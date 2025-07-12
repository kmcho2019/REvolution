module traffic_light #(
    parameter GREEN_TIME  = 6'd60,
    parameter YELLOW_TIME = 6'd5,
    parameter RED_TIME    = 6'd10,
    parameter MIN_GREEN   = 6'd10
)(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
typedef enum logic [1:0] {
    ST_IDLE,
    ST_RED,
    ST_YELLOW,
    ST_GREEN
} state_t;

reg [1:0] state, next_state;
reg [5:0] counter;

assign clock = counter;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= ST_IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    // Default outputs
    red = 1'b0;
    yellow = 1'b0;
    green = 1'b0;
    next_state = state;
    
    case (state)
        ST_IDLE: begin
            next_state = ST_RED;
        end
        
        ST_RED: begin
            red = 1'b1;
            if (counter == 6'd1) begin
                next_state = ST_GREEN;
            end
        end
        
        ST_YELLOW: begin
            yellow = 1'b1;
            if (counter == 6'd1) begin
                next_state = ST_RED;
            end
        end
        
        ST_GREEN: begin
            green = 1'b1;
            if (counter == 6'd1) begin
                next_state = ST_YELLOW;
            end
        end
    endcase
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= RED_TIME;
    end else begin
        case (state)
            ST_IDLE: begin
                counter <= RED_TIME;
            end
            
            ST_RED: begin
                if (counter == 6'd1) begin
                    counter <= GREEN_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            ST_YELLOW: begin
                if (counter == 6'd1) begin
                    counter <= RED_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            ST_GREEN: begin
                // Handle pedestrian request
                if (pass_request && (counter > MIN_GREEN)) begin
                    counter <= MIN_GREEN;
                end else if (counter == 6'd1) begin
                    counter <= YELLOW_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

endmodule