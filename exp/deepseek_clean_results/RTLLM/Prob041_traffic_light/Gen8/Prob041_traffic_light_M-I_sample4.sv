module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output [1:0] light  // 00: off, 01: red, 10: yellow, 11: green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// One-hot state encoding with gray coding
localparam [3:0] IDLE  = 4'b0001;
localparam [3:0] RED   = 4'b0010;
localparam [3:0] YELLOW = 4'b0100;
localparam [3:0] GREEN = 4'b1000;

reg [3:0] state, next_state;

// Counter with clock gating
reg [5:0] cnt;
wire counter_enable = (cnt > 1) || (state != next_state);

// Combined light output encoding
reg [1:0] light_reg;
assign light = light_reg;

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    next_state = state;
    light_reg = 2'b00;
    
    case (1'b1) // synthesis parallel_case
        state[0]: begin // IDLE
            next_state = RED;
        end
        
        state[1]: begin // RED
            light_reg = 2'b01;
            if (cnt == 1) next_state = GREEN;
        end
        
        state[2]: begin // YELLOW
            light_reg = 2'b10;
            if (cnt == 1) next_state = RED;
        end
        
        state[3]: begin // GREEN
            light_reg = 2'b11;
            if (cnt == 1) next_state = YELLOW;
        end
    endcase
end

// Counter management with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (counter_enable) begin
        // Handle pedestrian request
        if (pass_request && state[3] && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 1) begin
            case (1'b1) // synthesis parallel_case
                state[1]: cnt <= GREEN_TIME;  // RED -> GREEN
                state[2]: cnt <= RED_TIME;    // YELLOW -> RED
                state[3]: cnt <= YELLOW_TIME; // GREEN -> YELLOW
                default: cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

endmodule