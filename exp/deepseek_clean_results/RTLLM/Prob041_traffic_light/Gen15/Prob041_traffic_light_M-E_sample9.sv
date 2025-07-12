module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [6:0] clock,  // Extra bit for state encoding
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters with state encoding in MSB
parameter GREEN_TIME  = 7'd60;
parameter YELLOW_TIME = 7'd5;
parameter RED_TIME   = 7'd10;
parameter MIN_GREEN  = 7'd10;

// State ranges (encoded in counter MSBs)
localparam GREEN_RANGE  = 7'b1xxxxxx;  // 64-127
localparam YELLOW_RANGE = 7'b01xxxxx;  // 32-63
localparam RED_RANGE    = 7'b001xxxx;  // 16-31

reg [6:0] counter;  // Combines state and countdown

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= RED_TIME;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Handle pedestrian request during green phase
        if ((counter[6:5] == 2'b10) && pass_request && 
            (counter > MIN_GREEN) && (counter < GREEN_TIME)) begin
            counter <= MIN_GREEN;
        end
        // Normal countdown and state transitions
        else if (counter > 1) begin
            counter <= counter - 1;
        end
        else begin
            // State transition logic
            case (1'b1)
                counter[6]: begin  // Green -> Yellow
                    counter <= YELLOW_TIME;
                end
                counter[5]: begin  // Yellow -> Red
                    counter <= RED_TIME;
                end
                counter[4]: begin  // Red -> Green
                    counter <= GREEN_TIME;
                end
                default: counter <= RED_TIME;
            endcase
        end

        // Output generation
        red    <= (counter[6:4] == 3'b001);
        yellow <= (counter[6:4] == 3'b010);
        green  <= (counter[6:4] == 3'b100);
    end
end

assign clock = counter;

endmodule