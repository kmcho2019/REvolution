module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
localparam [1:0] RED    = 2'b00;
localparam [1:0] YELLOW = 2'b01;
localparam [1:0] GREEN  = 2'b10;

// Timing parameters
localparam [5:0] RED_TIME    = 6'd10;
localparam [5:0] YELLOW_TIME = 6'd5;
localparam [5:0] GREEN_TIME  = 6'd60;
localparam [5:0] MIN_GREEN   = 6'd10;

reg [1:0] state;
reg [5:0] cnt;

// Combined state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        case (state)
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            GREEN: begin
                if (pass_request && (cnt > MIN_GREEN)) begin
                    cnt <= MIN_GREEN;
                end else if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            default: begin
                state <= RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

// Direct combinatorial outputs
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

endmodule