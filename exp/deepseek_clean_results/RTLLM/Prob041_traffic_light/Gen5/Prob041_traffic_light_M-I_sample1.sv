module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding for area efficiency
parameter [2:0] RED_ST    = 3'b001;
parameter [2:0] YELLOW_ST = 3'b010;
parameter [2:0] GREEN_ST  = 3'b100;

// Time constants
parameter GREEN_TIME  = 6'd60;
parameter YELLOW_TIME = 6'd5;
parameter RED_TIME    = 6'd10;
parameter REQ_TIME    = 6'd10;

reg [2:0] state;
reg [5:0] timer;
wire timer_zero = (timer == 6'd1);
wire green_active = (state == GREEN_ST);
wire yellow_active = (state == YELLOW_ST);
wire red_active = (state == RED_ST);

// Output assignment
assign clock = timer;

// Clock gating signals
wire output_en = timer_zero || pass_request;

// Combined state and timer register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED_ST;
        timer <= RED_TIME;
    end else begin
        case (state)
            RED_ST: begin
                if (timer_zero) begin
                    state <= GREEN_ST;
                    timer <= GREEN_TIME;
                end else begin
                    timer <= timer - 6'd1;
                end
            end
            
            YELLOW_ST: begin
                if (timer_zero) begin
                    state <= RED_ST;
                    timer <= RED_TIME;
                end else begin
                    timer <= timer - 6'd1;
                end
            end
            
            GREEN_ST: begin
                if (pass_request && (timer > REQ_TIME)) begin
                    timer <= REQ_TIME;
                end else if (timer_zero) begin
                    state <= YELLOW_ST;
                    timer <= YELLOW_TIME;
                end else begin
                    timer <= timer - 6'd1;
                end
            end
            
            default: begin
                state <= RED_ST;
                timer <= RED_TIME;
            end
        endcase
    end
end

// Clock-gated output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else if (output_en) begin
        red <= red_active;
        yellow <= yellow_active;
        green <= green_active;
    end
end

endmodule